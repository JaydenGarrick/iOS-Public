//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    var post: Post?{
        didSet{
            loadViewIfNeeded()
            updateViews()
            
        }
    }
    

    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        let comment = post?.comments[indexPath.row]
        
        cell.textLabel?.text = comment?.text
        
        if let timestamp = comment?.timestamp{
            cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        }
        
        return cell
    }
    
    func updateViews(){
        guard let post = post else {return}
        photoImageView.image = post.photo
        
        PostController.shared.checkForSubscription(to: post) { (isSubscribed) in
            DispatchQueue.main.async {
                let buttonTitle = isSubscribed ? "Unfollow" : "Follow"
                self.followButton.setTitle(buttonTitle, for: .normal)
            }
        }
    }
    
    func presentCommentAlertController(){
        
        let alertController = UIAlertController(title: "Leave a Comment", message: "Tell us your thoughts on this post.  This app is anonomous so don't hold back (:", preferredStyle: .alert)
        
        alertController.addTextField { (commentTextField) in
            commentTextField.placeholder = "Your comment here"
        }
        
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard var commentText = alertController.textFields?.first?.text, let post = self.post else {return}
            guard !commentText.isEmpty else {return}
            PostController.shared.addComment(commentText, to: post, completion: { (comment) in
                DispatchQueue.main.async {
                    guard let comment = comment else { return }
                    commentText = comment.text
                    self.tableView.reloadData()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        presentCommentAlertController()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let post = post, let photo = post.photo else {return}
        let activityViewController = UIActivityViewController(activityItems: [photo, post.caption], applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true)
        }
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        guard let post = post else {return}
        PostController.shared.toggleSubscriptionTo(commentsForPost: post) { (success, error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                return
            }
            if success{
                DispatchQueue.main.async {
                    self.updateViews()
                }
            }
        }
    }
}
