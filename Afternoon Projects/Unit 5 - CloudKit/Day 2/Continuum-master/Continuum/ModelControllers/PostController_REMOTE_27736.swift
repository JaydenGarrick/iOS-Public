//
//  PostController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

extension PostController {
    static let PostsChangedNotification = Notification.Name("PostsChangedNotification")
}

class PostController{
    
    static let shared = PostController()
    private init() {}
    let publicDB = CKContainer.default().publicCloudDatabase
    
    var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: PostController.PostsChangedNotification, object: self)
            }
        }
    }
    
    
    // MARK: - CloudKit Availablity
    
    func checkAccountStatus(completion: @escaping (_ isLoggedIn: Bool) -> Void) {
        CKContainer.default().accountStatus { [weak self] (status, error) in
            if let error = error {
                print("Error checking accountStatus \(error) \(error.localizedDescription)")
                completion(false); return
            } else {
                let errrorText = "Sign into iCloud in Settings"
                switch status {
                case .available:
                   completion(true)
                case .noAccount:
                    let noAccount = "No account found"
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: noAccount)
                    completion(false)
                case .couldNotDetermine:
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: "Error with iCloud account status")
                    completion(false)
                case .restricted:
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: "Restricted iCloud account")
                    completion(false)
                }
            }
        }
    }
    
    func presentErrorAlert(errorTitle: String, errorMessage: String) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.showAlertMessage(titleStr: errorTitle, messageStr: errorMessage)
            }
        }
        
    }
    
    // MARK: - Create
    
    func createPostWith(captionText: String, photo: UIImage, completion: @escaping (Post?) -> ()){
        let post = Post(caption: captionText, photo: photo)
        self.posts.append(post)
        publicDB.save(CKRecord(post)) { (_, error) in
            if let error = error {
                print("Error saving post record \(error) \(error.localizedDescription)")
                completion(nil);return
            }
            completion(post)
        }
    }
    
    func addComment(_ text: String, to post: Post, completion: @escaping (Comment?) -> ()){
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        
        publicDB.save(CKRecord(comment)) { (record, error) in
            if let error = error {
                print("Error saving Comment: \(error) \(error.localizedDescription)")
                completion(nil);return
            }
            completion(comment)
        }
    
    }
    
    
    func addSubscritptionTO(commentsForPost post: Post, alertBody: String?, completion: ((Bool, Error) -> ())?){
        let postRecordID = post.recordID
        
        //Might need to change this predicate
        let predicate = NSPredicate(format: "post = %@", postRecordID)
        let subscription = CKQuerySubscription(recordType: post.recordTypeKey, predicate: predicate, subscriptionID: UUID().uuidString, options: .firesOnRecordCreation)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "A new comment was added a a post you follow!"
        notificationInfo.shouldSendContentAvailable = true
        notificationInfo.desiredKeys = nil
       subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
            }
        }
    }
    
    // MARK: - Fetch
    func fetchAllPostsFromCloudKit(completion: @escaping([Post]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Post", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("Error fetching posts from cloudKit \(#function) \(error) \(error.localizedDescription)")
                completion(nil);return 
            }
            
            guard let records = records else {completion(nil); return }
            
            let posts = records.compactMap{Post(record: $0)}
          
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchComments(from post: Post, completion: @escaping (Bool) -> Void) {
        let postRefence = CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "postReference == %@", postRefence)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
    
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("Error fetching comments from cloudKit \(#function) \(error) \(error.localizedDescription)")
                completion(false); return
            }
            
            guard let records = records else {completion(false); return }
            
            let comments = records.compactMap{Comment(record: $0)}
            post.comments.append(contentsOf: comments)
            completion(true)
        }
    }
    
    //
    
    
}
