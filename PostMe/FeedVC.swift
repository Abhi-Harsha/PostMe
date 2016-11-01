//
//  FeedVC.swift
//  PostMe
//
//  Created by Abhishek H P on 7/31/16.
//  Copyright © 2016 Abhishek H P. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var postTextField: UITextView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var imagePicker: UIImagePickerController!
    var i = 0
    static var feedImageCache = NSCache()
    var posts = [Post]()
    var Cloud_Name: String!
    var API_Key: String!
    var API_SECRET: String!
    var BASE_URL: String!
    var SECURE_URL: String!
    var API_BASE_URL: String!
    var Env_Variable: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker.delegate = self
        
        SwiftSpinner.show("Fetching user data...")
        
        DataService.ds.POST_URL.observeEventType(.Value, withBlock: { (snapshots) in
            self.posts = []
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let data = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dict: data)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        })
        getAPIDetails()
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        var img: UIImage?
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            if let url = post.ImageUrl {
            if FeedVC.feedImageCache.objectForKey(url) != nil {
                    img = FeedVC.feedImageCache.objectForKey(url) as? UIImage
                    cell.setUpCell(post, img: img)
                }
            }
            cell.setUpCell(post, img: img)
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.selectedImageView.image = image
    }

    @IBAction func onImagePressed(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func onPostPressed(sender: MaterialButton) {
        
        
    }
    
    func getAPIDetails() {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)!
        
        if let name = dict["Cloudinary Cloud Name"] as? String {
            self.Cloud_Name = name
        }
        
        if let secret = dict["Cloudinary API SECRET"] as? String {
            self.API_SECRET = secret
        }
        
        if let key = dict["Cloudninary API KEY"] as? String {
            self.API_Key = key
        }
        
        if let baseUrl = dict["Cloudinary Base URL"] as? String {
            self.BASE_URL = baseUrl
        }
        
        if let apiBaseUrl = dict["Cloudinary API BASE URL"] as? String {
            self.API_BASE_URL = apiBaseUrl
        }
        
        if let secureUrl = dict["Cloudinary Secure URL"] as? String {
            self.SECURE_URL = secureUrl
        }
        
        if let envVar = dict["Cloudinary Env Variable"] as? String {
            self.Env_Variable = envVar
        }
    }
    
    
    
    
    
    
    
    
}
