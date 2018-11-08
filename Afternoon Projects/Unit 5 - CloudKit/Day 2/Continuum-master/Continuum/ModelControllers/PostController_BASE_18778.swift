//
//  PostController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostController{
    
    static let shared = PostController()
    private init() {}
    let publicDB = CKContainer.default().publicCloudDatabase
    
    var posts = [Post]()
    
    // MARK: - CloudKit Availablity
    
    func checkAccountStatus(completion: @escaping (_ isLoggedIn: Bool) -> Void) {
        CKContainer.default().accountStatus { [weak self] (status, error) in
            if let error = error {
                print("Error checking accountStatus \(error) \(error.localizedDescription)")
                completion(false); return
            } else {
                let errrorText = "Sing in to iCloud in Settings"
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
    
    
    func addComment(_ text: String, to post: Post, completion: (Comment) -> ()){
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
    }
    
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
}
