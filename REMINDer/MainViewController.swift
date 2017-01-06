//
//  ViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 12/19/16.
//  Copyright © 2016 reminder.com. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit
import PubNub

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnStartPressed(_ sender: UIButton) {
        let exampleViewController = MessengerViewController()
        navigationController?.pushViewController(exampleViewController, animated: true)
    }
}

