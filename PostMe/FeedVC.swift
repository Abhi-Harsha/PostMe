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
import Alamofire
import Firebase

class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var postTextField: UITextView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var imagePicker: UIImagePickerController!
    let defaultImageName = "camera"
    var i = 0
    static var feedImageCache = NSCache<AnyObject, AnyObject>()
    var posts = [Post]()
    var Cloud_Name: String!
    var API_Key: String!
    var API_SECRET: String!
    var BASE_URL: String!
    var SECURE_URL: String!
    var API_BASE_URL: String!
    var Env_Variable: String!
    var imgShackApiKey: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedImageView.image = UIImage(named: defaultImageName)
        imagePicker = UIImagePickerController()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker.delegate = self
        
        SwiftSpinner.show("Fetching user data...")
        
        DataService.ds.POST_URL.observe(.value, with: { (snapshots) in
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
            self.posts = self.posts.sorted(by: { $0.PostKey  > $1.PostKey })
            self.tableView.reloadData()
            SwiftSpinner.hide()
        })
        getAPIDetails()
    }
    

    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        var img: UIImage?
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            if let url = post.ImageUrl {
            if FeedVC.feedImageCache.object(forKey: url as AnyObject) != nil {
                    img = FeedVC.feedImageCache.object(forKey: url as AnyObject) as? UIImage
                cell.setUpCell(post: post, img: img)
                }
            }
            cell.setUpCell(post: post, img: img)
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.selectedImageView.image = image
    }

    @IBAction func onImagePressed(sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func onPostPressed(sender: MaterialButton) {
        guard let descText = postTextField.text, descText != "" else{
            return
        }
        var imglink: String?
        SwiftSpinner.show("Posting...")
        let storage = FIRStorage.storage()
        //check if default image is selected or not
        if let selectedImage = self.selectedImageView.image, selectedImage != UIImage(named: defaultImageName)  {
            let urlStr = "https://post.imageshack.us/upload_api.php"
            let url = URLRequest(url: URL(string: "\(urlStr)")!)
            let imgData = UIImageJPEGRepresentation(selectedImage, 0.3)
            let keyData = imgShackApiKey.data(using: String.Encoding.utf8)
            let keyJSON = "json".data(using: String.Encoding.utf8)
    
            
//            Alamofire.upload( multipartFormData :
//                { multipartFormData in
//                multipartFormData.append(imgData!, withName: "fileupload", fileName: "image", mimeType: "image/jpg")
//            }, to: URL, encodingCompletion: {
//                encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint("SUCCESS RESPONSE: \(response)")
//                    }
//                case .failure(let encodingError):
//                    // hide progressbas here
//                    print("ERROR RESPONSE: \(encodingError)")
//                }
//            })
          
        } else {
            self.makeNewFirebasePost(imgUrl: imglink, desc: descText)
        }
    }
    
    func makeNewFirebasePost(imgUrl: String?, desc: String){
        var post: Dictionary<String, AnyObject> = [
            "Description": "\(desc)" as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        if let imglink = imgUrl {
            post["imageURL"] = "\(imglink)" as String as AnyObject?
        } else {
            post["imageURL"] = nil
        }
        let newChild = DataService.ds.POST_URL.childByAutoId()
        newChild.setValue(post)
        tableView.reloadData()
        postTextField.text = ""
        self.selectedImageView.image = UIImage(named: defaultImageName)
        SwiftSpinner.hide()
    }
    
    func getAPIDetails() {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
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
        
        if let imgApiKey = dict["Img Shack API Key"] as? String {
            self.imgShackApiKey = imgApiKey
        }
    }
    
    
    
    
    
    
    
}
