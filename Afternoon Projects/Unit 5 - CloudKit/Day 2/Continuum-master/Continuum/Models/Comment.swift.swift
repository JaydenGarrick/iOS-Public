//
//  Comment.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

class Comment{
    
    let typeKey = "Comment"
    fileprivate let textKey = "text"
    fileprivate let timestampKey = "timstamp"
    fileprivate let postReferenceKey = "postReference"
    
    let recordID = CKRecord.ID(recordName: UUID().uuidString)
    var text: String
    var timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?){
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}

extension CKRecord {
    convenience init(_ comment: Comment) {
<<<<<<< Updated upstream
        guard let post = comment.post else {
            fatalError("Comment does not have a Post relationship")
        }
        self.init(recordType: comment.typeKey, recordID: comment.recordID)
=======
        guard let post = comment.post else { fatalError("Comment does not have a Post relationship") }
        let recordID = CKRecord.ID(recordName: UUID().uuidString)
        self.init(recordType: comment.typeKey, recordID: recordID)
>>>>>>> Stashed changes
        self.setValue(comment.text, forKey: comment.typeKey)
        self.setValue(comment.timestamp, forKey: comment.timestampKey)
        self.setValue(CKRecord.Reference(recordID: post.recordID, action: .deleteSelf), forKey: comment.postReferenceKey)
    }
}

extension Comment: SearchableRecord{
    
    func matches(searchTerm: String) -> Bool {
        return self.text.lowercased().contains(searchTerm.lowercased())
    }
}
