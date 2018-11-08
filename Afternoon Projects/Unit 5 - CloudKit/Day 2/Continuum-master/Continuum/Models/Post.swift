//
//  Post.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class Post{
    
    let recordTypeKey = "Post"
    fileprivate let captionKey = "caption"
    fileprivate let timestampKey = "timestamp"
    fileprivate let photoDataKey = "photoData"
    
    var recordID = CKRecord.ID(recordName: UUID().uuidString)
    var caption: String
    var photoData: Data?
    var timestamp: Date
    var comments: [Comment] = []
    var tempURL: URL?
    
    init(caption: String, photo: UIImage, comments: [Comment] = [], timestamp: Date = Date()){
        self.caption = caption
        self.comments = comments
        self.timestamp = timestamp
        self.photo = photo
    }
    
    var photo: UIImage?{
        get{
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.6)
        }
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            self.tempURL = fileURL
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    
    deinit {
        if let url = tempURL {
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error {
                print("Error deleting temp file, or may cause memory leak: \(error)")
            }
        }
    }
    
    // MARK: - Fetching
     init?(record: CKRecord) {
        guard let caption = record[captionKey] as? String,
            let timestamp = record.creationDate,
            let imageAsset = record[photoDataKey] as? CKAsset else { return nil }
//        self.imageAsset = photoAsset
        guard let photoData = try? Data(contentsOf: imageAsset.fileURL) else { return nil }
    
        self.caption = caption
        self.timestamp = timestamp
        self.photoData = photoData
        self.comments = []
        self.recordID = record.recordID
    }
}

extension CKRecord {
    convenience init(_ post: Post) {
        let recordID = post.recordID
        self.init(recordType: post.recordTypeKey, recordID: recordID)
        self.setValue(post.caption, forKey: post.captionKey)
        self.setValue(post.timestamp, forKey: post.timestampKey)
        self.setValue(post.imageAsset, forKey: post.photoDataKey)
        
    }
}

extension Post: SearchableRecord{
    
    func matches(searchTerm: String) -> Bool {
        
        if caption.lowercased().contains(searchTerm.lowercased()){
            return true
        }
        
        for comment in self.comments{
            if comment.matches(searchTerm: searchTerm){
                return true
            }
        }
        return false
    }
}
