//
//  Extentions.swift
//  Continuum
//
//  Created by Nick Reichard on 9/20/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

// MARK: - UIViewController

extension UIViewController {
    func showAlertMessage(titleStr:String, messageStr:String) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

