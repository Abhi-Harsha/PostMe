//
//  PostCell.swift
//  PostMe
//
//  Created by Abhishek H P on 8/1/16.
//  Copyright © 2016 Abhishek H P. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postDescTxtView: UITextView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    
    var request: Request?

    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }
    
    func setUpCell(post: Post, img: UIImage?) {
        
        if let desc = post.PostDescription {
             postDescTxtView.text = desc
        }
        likesLbl.text = "\(post.Likes)"
        
        if let feedImg = img {
            self.postImg.image = feedImg
            print("image picked up from cache")
        } else {
            if let url = post.ImageUrl {
                request = Alamofire.request(.GET, url).validate(contentType: ["image/*"]).response(completionHandler: { (request, reponse, data, error) in
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        if let imgdata = data {
                            let img = UIImage(data: imgdata)
                            self.postImg.image = img
                            FeedVC.feedImageCache.setObject(img!, forKey: url)
                            print("image added to cache \(url)")
                        }
                    }
                })
            } else {
                postImg.hidden = true
                print("image hidden\(post.PostDescription)")
            }
        }

    }
}
