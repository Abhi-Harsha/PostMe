//
//  PostCell.swift
//  PostMe
//
//  Created by Abhishek H P on 8/1/16.
//  Copyright © 2016 Abhishek H P. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
//    @IBOutlet weak var postImg: UIImageView!
//    @IBOutlet weak var postDescTxtView: UITextView!
//    @IBOutlet weak var userNameLbl: UILabel!
//    @IBOutlet weak var likesLbl: UILabel!

    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }


}
