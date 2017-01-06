//
//  SettingsViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 1/6/17.
//  Copyright © 2017 reminder.com. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ButtonCharPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SettingsToCharIdentifier", sender: self)
    }
}
