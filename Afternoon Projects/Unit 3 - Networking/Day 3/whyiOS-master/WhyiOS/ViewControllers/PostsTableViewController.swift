//
//  PostsTableViewController.swift
//  WhyiOS2
//
//  Created by Jayden Garrick on 5/23/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//



/*
 Don't
 Repeat
 Yourself
 */

import UIKit

class PostsTableViewController: UITableViewController {
    
    // Source of truth
    var fetchedPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    // MARK: - IBActions
    func refresh() {
        PostController.fetchPosts { (posts) in
            guard let posts = posts else { return }
            self.fetchedPosts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        refresh()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddReasonAlert()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        let post = fetchedPosts[indexPath.row]
        cell.nameLabel.text = post.name
        cell.cohortLabel.text = post.cohort
        cell.reasonLabel.text = post.reason
        
        return cell
    }
    
}

// MARK: - Alerts
extension PostsTableViewController {
    
    func presentAddReasonAlert() {
        var nameTextFieldForReason: UITextField?
        var reasonTextFieldForReason: UITextField?
        var cohortTextFieldForReason: UITextField?
        
        let reasonAlert = UIAlertController(title: "Why did you choose to learn iOS?", message: nil, preferredStyle: .alert)
        
        reasonAlert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Enter your name"
            nameTextFieldForReason = nameTextField
        }
        reasonAlert.addTextField { (cohortTextField) in
            cohortTextField.placeholder = "Enter your cohort name"
            cohortTextFieldForReason = cohortTextField
        }
        
        reasonAlert.addTextField { (reasonTextField) in
            reasonTextField.placeholder = "Why are you iOS?"
            reasonTextFieldForReason = reasonTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addReasonAction = UIAlertAction(title: "Add Reason", style: .default) { (_) in
            guard let name = nameTextFieldForReason?.text,
                let cohort = cohortTextFieldForReason?.text,
                let reason = reasonTextFieldForReason?.text else { return }
            PostController.postReason(name: name, reason: reason, cohort: cohort, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.refresh()
                    }
                } else {
                    print("Fail")
                }
            })
        }
        reasonAlert.addAction(addReasonAction)
        reasonAlert.addAction(cancelAction)
        present(reasonAlert, animated: true)
    }
    
}
