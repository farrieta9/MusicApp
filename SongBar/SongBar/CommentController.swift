//
//  CommentController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/15/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class CommentController: UITableViewController {
    
    fileprivate let cellId = "cell"
    var tableData = [Comment]()
    var usersIdInChat = [String]()
    var commentReference: String? {
        didSet {
            observeComments()
        }
    }
    
    lazy var inputContainerView: InputContainerView = {
        let contentView = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    fileprivate func setUpView() {
        navigationItem.title = "Comment"
        tableView.allowsSelection = false
        tableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorInset = UIEdgeInsets.zero
        inputContainerView.inputTextField.delegate = self
        inputContainerView.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    }
    
    fileprivate func observeComments() {
        guard let reference = commentReference else {
            return
        }
        
        FIRDatabase.database().reference().child("comments").child(reference).observe(.childAdded, with: { (snapshot) in
            
            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            if let commentatorId = result["commentator"] as? String {
                
                FIRDatabase.database().reference().child("users").child(commentatorId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    guard let resultOfUser = snapshot.value as? [String: AnyObject] else {
                        return
                    }
                    let user = User()
                    user.setValuesForKeys(resultOfUser)
                    
                    
                    let comment = Comment()
                    comment.user = user
                    comment.comment = result["comment"] as? String
                    comment.timestamp = result["timestamp"] as? String
                    
                    self.tableData.append(comment)
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                    
                }, withCancel: nil)
            }
        }, withCancel: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentCell
        
        cell.comment = tableData[(indexPath as NSIndexPath).row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func handleSend() {
        print("handleSend")
    }
}

extension CommentController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleSend()
        return true
    }
}
