//
//  ShareController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/10/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class ShareController: UITableViewController {
    
    var selectedRows = [Int]()
    private let cellId = "cellId"
    var timer: NSTimer? = nil
    var track: SpotifyTrack?
    var fansData: [User] = [User]()
    
    lazy var inputContainerView: InputContainerView = {
        let contentView = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        return contentView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Fans"
        tableView.allowsMultipleSelection = true
        tableView.registerClass(ContentCell.self, forCellReuseIdentifier: cellId)
        observeFans()
        inputContainerView.inputTextField.delegate = self
        inputContainerView.sendButton.addTarget(self, action: #selector(self.handleSend), forControlEvents: .TouchUpInside)
    }
    
    func handleSend() {
        if selectedRows.count == 0 {
            return
        }
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        guard let track = track else {
            return
        }
        
        let date = String(Int(NSDate().timeIntervalSince1970))
        let comment = inputContainerView.inputTextField.text!
        
        var value = ["title": track.title, "artist": track.artist, "imageUrl": track.imageUrl, "previewUrl": track.previewUrl, "comment": comment]
        
        FIRDatabase.database().reference().child("songs-sent").child(uid).child(date).updateChildValues(value)
        
        value["donor"] = uid
        
        FIRDatabase.database().reference().child("songs-shared").child(uid).child(date).updateChildValues(value)
        
        
        
        for row in selectedRows {
            if let fanUid = fansData[row].uid {
                FIRDatabase.database().reference().child("songs-shared").child(fanUid).child(date).updateChildValues(value)
            }
        }
        
        navigationController?.popViewControllerAnimated(true)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if MusicPlayer.playView?.hidden == false {
            MusicPlayer.playView?.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if MusicPlayer.playView?.hidden == true {
            MusicPlayer.playView?.hidden = false
        }
    }
    
    func observeFans() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users-fans").child(uid).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            FIRDatabase.database().reference().child("users").child(snapshot.key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                guard let result = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let user = User()
                user.uid = snapshot.key
                user.setValuesForKeysWithDictionary(result)
                
                if let imageUrl = result["imageUrl"] as? String {
                    user.imageUrl = imageUrl
                }
                
                self.fansData.append(user)
                self.attemptReloadTable()
                
                }, withCancelBlock: nil)
        }, withCancelBlock: nil)
    }
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}

extension ShareController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fansData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ContentCell
        cell.user = fansData[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContentCell
        
        cell.accessoryType = .Checkmark
        selectedRows.append(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContentCell
        cell.accessoryType = .None
        
        let index = selectedRows.indexOf(indexPath.row)
        if let i = index {
            selectedRows.removeAtIndex(i)
        }
    }
}

extension ShareController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}