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
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.darkGray.cgColor
        
    }
    //placebolder
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    //editing
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

}
