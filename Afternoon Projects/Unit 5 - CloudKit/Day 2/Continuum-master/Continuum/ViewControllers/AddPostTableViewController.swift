//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var captionTextField: UITextField!
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelectVC"{
            guard let destinationVC = segue.destination as? PhotoSelectViewController else {return}
            destinationVC.delegate = self
        }
    }
    
    func someFunc(){
        //Contains the Goods
        print("The Goods")
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let photo = photo, let caption = captionTextField.text, !caption.isEmpty else {return}
        PostController.shared.createPostWith(captionText: caption, photo: photo) { (post) in

        }
        self.tabBarController?.selectedIndex = 0
    }
}

extension AddPostTableViewController: PhotoSelectViewControllerDelegate{
    
    func photoSelected(_ photo: UIImage) {
        self.photo = photo
    }
    
}
