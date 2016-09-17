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
    
    lazy var settingsLauncher: SettingsController = {
        let launcher = SettingsController()
        launcher.userController = self
        return launcher
    }()
    
    var timer: Timer? = nil
    var followingData = [User]()
    var fansData = [User]()
    var postData = [SpotifyTrack]()
    
    enum ContentOptions {
        case posts, fans, following
    }
    
    var contentOption: ContentOptions = .posts
	
    fileprivate let cellId = "cellId"
    
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
            
//            headerView.followButton.hidden = true
            if user.uid == FIRAuth.auth()?.currentUser?.uid {
                headerView.followButton.isHidden = true
            } else {
                headerView.followButton.isHidden = false
            }
            
            observePosts()
            observeFollowing()
            observeFans()
            
        }
    }
    

    let headerView: UserHeader = {
        let view = UserHeader()
        return view
    }()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        tableView.tableHeaderView = headerView
        tableView.register(ContentCell.self, forCellReuseIdentifier: cellId)
        observeSignedInUser()
        
        headerView.segmentControl.addTarget(self, action: #selector(self.handleSegmentControl), for: .valueChanged)
        headerView.followButton.addTarget(self, action: #selector(self.handleFollowButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(handleSettings))
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
        guard let uid = user?.uid, let signedInUserUid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }

        FIRDatabase.database().reference().child("users-following").child(signedInUserUid).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.value is NSNull {
                self.headerView.followButton.setTitle("+ Follow", for: UIControlState())
                self.headerView.followButton.backgroundColor = UIColor.clear
            } else {
                self.headerView.followButton.setTitle("Following", for: UIControlState())
                self.headerView.followButton.backgroundColor = UIColor.rgb(13, green: 159, blue: 224)
            }
            
        }, withCancel: nil)
    }
    
    fileprivate func followUser(_ user: User) {
        
        guard let uid = user.uid, let signedInUserUid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users-following").child(signedInUserUid).updateChildValues([uid: 1])
        FIRDatabase.database().reference().child("users-fans").child(uid).updateChildValues([signedInUserUid: 1])
        
        headerView.followButton.setTitle("Following", for: UIControlState())
        headerView.followButton.backgroundColor = UIColor.rgb(13, green: 159, blue: 224)
    }
    
    func unFollowUser(_ user: User) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users-following").child(uid).child(user.uid!).removeValue()
        FIRDatabase.database().reference().child("users-fans").child(user.uid!).child(uid).removeValue()
        
        headerView.followButton.setTitle("+ Follow", for: UIControlState())
        headerView.followButton.backgroundColor = UIColor.clear
    }
    
    func handleSegmentControl() {
        switch headerView.segmentControl.selectedSegmentIndex {
        case 0:
            contentOption = .posts
        case 1:
            contentOption = .fans
        case 2:
            contentOption = .following
        default:
            break
        }
        
        attemptReloadTable()
    }
    
    fileprivate func observeSignedInUser() {
        if user != nil {
            return
        }
        
//        headerView.followButton.hidden = true
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.setValuesForKeys(result)
            user.uid = snapshot.key
            
            self.user = user
            
        }, withCancel: nil)
    }
    
    func observeFollowing() {
        
        guard let uid = user?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users-following").child(uid).observe(.childAdded, with: { (snapshot) in
            
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
                
                self.followingData.append(user)
                self.attemptReloadTable()
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func observeFans() {
        guard let uid = user?.uid else {
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
    
    func observePosts() {
        guard let uid = user?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("songs-sent").child(uid).observe(.childAdded, with: { (snapshot) in
            
            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let track = SpotifyTrack()
            track.setValuesForKeys(result)
            
            self.postData.append(track)
            self.attemptReloadTable()
            
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
    
    func handleSettings() {
        settingsLauncher.showSettings()
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        present(navController, animated: true, completion: nil)
    }
    
    func showUserControllerForUser(_ user: User) {
        let userController = UserController()
        userController.user = user
        userController.checkIfFollowing()
        navigationController?.pushViewController(userController, animated: true)
    }
}

extension UserController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentOption {
        case .posts:
            return postData.count
        case .fans:
            return fansData.count
        case .following:
            return followingData.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContentCell
        
        cell.thumbnailImageView.loadImageUsingURLString("")
        switch contentOption {
        case .posts:
            cell.track = postData[(indexPath as NSIndexPath).row]
        case .fans:
            cell.user = fansData[(indexPath as NSIndexPath).row]
        case .following:
            cell.user = followingData[(indexPath as NSIndexPath).row]
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentOption {
        case .posts:
            MusicPlayer.playSong(postData[(indexPath as NSIndexPath).row])
            break
        case .fans:
            showUserControllerForUser(fansData[(indexPath as NSIndexPath).row])
            break
        case .following:
            showUserControllerForUser(followingData[(indexPath as NSIndexPath).row])
            break
        }
    }
}

extension UserController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        uploadUserImageToFirebase(image)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func uploadUserImageToFirebase(_ image: UIImage) {
        
        guard let uploadImage = UIImageJPEGRepresentation(image, 0.1), let uid = FIRAuth.auth()?.currentUser?.uid  else {
            return
        }
        
        FIRStorage.storage().reference().child("users-images").child(uid).put(uploadImage, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let imageURLString = metadata?.downloadURL()?.absoluteString else {
                return
            }
            
            let values = ["imageUrl": imageURLString]
            FIRDatabase.database().reference().child("users").child(uid).updateChildValues(values)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func launchImagePicker(_ sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.allowsEditing = false
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
}
