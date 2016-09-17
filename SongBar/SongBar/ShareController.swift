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
    fileprivate let cellId = "cellId"
    var timer: Timer? = nil
    var track: SpotifyTrack?
    var fansData: [User] = [User]()
    var hidAudioPlayer: Bool?
    
    lazy var inputContainerView: InputContainerView = {
        let contentView = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        return contentView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Fans"
        tableView.allowsMultipleSelection = true
        tableView.register(ContentCell.self, forCellReuseIdentifier: cellId)
        observeFans()
        inputContainerView.inputTextField.delegate = self
        inputContainerView.sendButton.addTarget(self, action: #selector(self.handleSend), for: .touchUpInside)
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
        
        let date = String(Int(Date().timeIntervalSince1970))
        let comment = inputContainerView.inputTextField.text!
        
        
        
        let ref = FIRDatabase.database().reference().child("comments").childByAutoId()

        var value = ["title": track.title, "artist": track.artist, "imageUrl": track.imageUrl, "previewUrl": track.previewUrl, "comment": comment, "commentReference": ref.key]
        
        FIRDatabase.database().reference().child("songs-sent").child(uid).child(date).updateChildValues(value)
        
        value["donor"] = uid
        
        FIRDatabase.database().reference().child("songs-shared").child(uid).child(date).updateChildValues(value)
        
        for row in selectedRows {
            if let fanUid = fansData[row].uid {
                FIRDatabase.database().reference().child("songs-shared").child(fanUid).child(date).updateChildValues(value)
            }
        }
        
        ref.childByAutoId().updateChildValues(["comment":comment, "commentator": uid, "timestamp": date])
        
        navigationController?.popViewController(animated: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MusicPlayer.playView?.isHidden == false {
            MusicPlayer.playView?.isHidden = true
            hidAudioPlayer = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if MusicPlayer.playView?.isHidden == true && hidAudioPlayer == true {
            MusicPlayer.playView?.isHidden = false
        }
    }
    
    func observeFans() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users-fans").child(uid).observe(.childAdded, with: { (snapshot) in
            
            FIRDatabase.database().reference().child("users").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let result = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let user = User()
                user.uid = snapshot.key
                user.setValuesForKeys(result)
                
                if let imageUrl = result["imageUrl"] as? String {
                    user.imageUrl = imageUrl
                }
                
                self.fansData.append(user)
                self.attemptReloadTable()
                
                }, withCancel: nil)
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ShareController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fansData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContentCell
        cell.user = fansData[(indexPath as NSIndexPath).row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ContentCell
        
        cell.accessoryType = .checkmark
        selectedRows.append((indexPath as NSIndexPath).row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ContentCell
        cell.accessoryType = .none
        
        let index = selectedRows.index(of: (indexPath as NSIndexPath).row)
        if let i = index {
            selectedRows.remove(at: i)
        }
    }
}

extension ShareController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
