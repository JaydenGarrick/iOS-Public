//
//  ViewController.swift
//  Flashlight
//
//  Created by Caleb Hicks on 9/23/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    var isOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(_ sender: Any) {
        
        if isOn {
            self.isOn = false
            
            self.button.setTitle("On", for: .normal)
            self.button.setTitleColor(UIColor.white, for: .normal)
            self.view.backgroundColor = UIColor.black
            
        } else {
            self.isOn = true
            
            self.button.setTitle("Off", for: .normal)
            self.button.setTitleColor(UIColor.black, for: .normal)
            self.view.backgroundColor = UIColor.white
        }
    
    }
  
}

