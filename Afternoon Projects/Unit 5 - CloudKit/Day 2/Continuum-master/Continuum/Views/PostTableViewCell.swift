//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var post: Post?{
        didSet{
            updateViews()
        }
    }

    func updateViews(){
        guard let post = post else {return}
        
        PostController.shared.fetchComments(from: post) { (success) in
            if success{
                DispatchQueue.main.async {
                    self.commentCountLabel.text = "\(post.comments.count) Comments"
                }
            }
        }
        photoImageView.image = post.photo
        captionLabel.text = post.caption
    }
    
    
}
