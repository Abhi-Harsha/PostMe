//
//  Post.swift
//  PostMe
//
//  Created by Abhishek H P on 10/5/16.
//  Copyright © 2016 Abhishek H P. All rights reserved.
//

import Foundation


class Post {
    private var _postDescription: String?
    private var _likes: Int!
    private var _imageUrl: String?
    private var _userName: String!
    private var _postKey: String!
    
    var PostDescription: String? {
            return _postDescription
    }
    
    var Likes: Int {
        return _likes
    }
    
    var ImageUrl: String? {
      return _imageUrl
    }
    
    var UserName: String {
        return _userName
    }
    
    var PostKey: String {
        return _postKey
    }
    
    init(postdesc: String, imageUrl: String, userName: String){
        self._postDescription = postdesc
        self._imageUrl = imageUrl
        self._userName = userName
    }
    
    init(postKey: String, dict: Dictionary<String, AnyObject>){
        
        self._postKey = postKey

        if let likes = dict["likes"] as? Int {
            self._likes = likes
        }
        
        if let description = dict["Description"] as? String {
            self._postDescription = description
        }
        
        if let url = dict["imageURL"] as? String {
            self._imageUrl = url
        }
    }
}