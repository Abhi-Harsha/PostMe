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

class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var i = 0
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
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
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            cell.setUpCell(post)
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

}
