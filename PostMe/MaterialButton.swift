//
//  MaterialButton.swift
//  PostMe
//
//  Created by Abhishek H P on 7/27/16.
//  Copyright © 2016 Abhishek H P. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor.darkGrayColor().CGColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(2.0, 2.0)
    }

}
