//
//  MaterialTextField.swift
//  PostMe
//
//  Created by Abhishek H P on 7/27/16.
//  Copyright © 2016 Abhishek H P. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor.darkGrayColor().CGColor
        layer.borderWidth = 1.0
    }
    //placebolder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    //editing
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
