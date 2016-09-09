//
//  UserController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class UserController: UITableViewController {
    
    enum ContentOptions {
        case Posts, Fans, Following
    }
    
    var contentOption: ContentOptions = .Posts
	
    private let cellId = "cellId"
    
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            
            headerView.usernameLabel.text = user.username
            headerView.fullnameLabel.text = user.email
            
            if let imageUrl = user.imageUrl {
                headerView.pictureView.loadImageUsingURLString(imageUrl)
            }
        }
    }

    let headerView: UserHeader = {
        let view = UserHeader()
        return view
    }()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        tableView.tableHeaderView = headerView
        tableView.registerClass(ContentCell.self, forCellReuseIdentifier: cellId)
        observeSignedInUser()
        
        headerView.segmentControl.addTarget(self, action: #selector(self.handleSegmentControl), forControlEvents: .ValueChanged)
        headerView.followButton.addTarget(self, action: #selector(self.handleFollowButton), forControlEvents: .TouchUpInside)
	}

    
    func handleFollowButton() {
        guard let user = user else {
            return
        }
        
        if headerView.followButton.titleLabel?.text == "+ Follow" {
            followUser(user)
        } else {
            unFollowUser(user)
        }
    }
    
    func checkIfFollowing() {
        guard let uid = user?.uid, signedInUserUid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }

        FIRDatabase.database().reference().child("users-following").child(signedInUserUid).child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if snapshot.value is NSNull {
                self.headerView.followButton.setTitle("+ Follow", forState: .Normal)
                self.headerView.followButton.backgroundColor = UIColor.clearColor()
            } else {
                self.headerView.followButton.setTitle("Following", forState: .Normal)
                self.headerView.followButton.backgroundColor = UIColor.rgb(13, green: 159, blue: 224)
            }
            
        }, withCancelBlock: nil)        
    }
    
    private func followUser(user: User) {
        
        guard let uid = user.uid, signedInUserUid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users-following").child(signedInUserUid).updateChildValues([uid: 1])
        FIRDatabase.database().reference().child("users-fans").child(uid).updateChildValues([signedInUserUid: 1])
        
        headerView.followButton.setTitle("Following", forState: .Normal)
        headerView.followButton.backgroundColor = UIColor.rgb(13, green: 159, blue: 224)
    }
    
    func unFollowUser(user: User) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users-following").child(uid).child(user.uid!).removeValue()
        FIRDatabase.database().reference().child("users-fans").child(user.uid!).child(uid).removeValue()
        
        headerView.followButton.setTitle("+ Follow", forState: .Normal)
        headerView.followButton.backgroundColor = UIColor.clearColor()
    }
    
    func handleSegmentControl() {
        switch headerView.segmentControl.selectedSegmentIndex {
        case 0:
            contentOption = .Posts
        case 1:
            contentOption = .Fans
        case 2:
            contentOption = .Following
        default:
            break
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView.reloadData()
        }
    }
    
    private func observeSignedInUser() {
        if user != nil {
            return
        }
        
        headerView.followButton.hidden = true
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeEventType(.Value, withBlock: { (snapshot) in
            
            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.setValuesForKeysWithDictionary(result)
            user.uid = snapshot.key
            
            self.user = user
            
            
        }, withCancelBlock: nil)
    }
}

extension UserController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ContentCell

        cell.textLabel?.text = "some username"
        return cell
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
}