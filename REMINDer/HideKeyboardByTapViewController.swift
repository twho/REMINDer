//
//  HideKeyboardByTapViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 1/5/17.
//  Copyright © 2017 reminder.com. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

