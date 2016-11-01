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
}
