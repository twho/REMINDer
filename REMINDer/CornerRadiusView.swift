
//
//  CornerRadiusView.swift
//  REMINDer
//
//  Created by Michael Ho on 1/6/17.
//  Copyright © 2017 reminder.com. All rights reserved.
//

import UIKit

class CornerRadiusImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = CGFloat(2.0)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.width/8
        self.clipsToBounds = true
    }
}
