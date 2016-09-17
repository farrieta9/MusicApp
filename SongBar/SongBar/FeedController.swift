//
//  ViewController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class FeedController: UICollectionViewController {
	
    var timer: Timer? = nil
    var tracksData = [SpotifyTrack]()
	fileprivate let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
        checkIfUserIsSignedIn()
		navigationItem.title = "Feed"
		collectionView?.backgroundColor = UIColor.white
		collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        collectionView?.alwaysBounceVertical = true
        observeFeed()
	}
    
    func checkIfUserIsSignedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // To remove error 'Unbalanced calls to begin end appearance transitions for UINavCtrl
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let results = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = results["username"] as? String
                }
                
            }, withCancel: nil)
        }
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
    
    fileprivate func observeFeed() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("songs-shared").child(uid).observe(.childAdded, with: { (snapshot) in
            
            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let track = SpotifyTrack()
            track.setValuesForKeys(result)
            track.timestamp = Int(snapshot.key) as NSNumber?
            self.tracksData.append(track)
            
            self.attemptReloadTable()
            
            
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        
        self.tracksData.sort { (track1, track2) -> Bool in
            // Decending order
            return track1.timestamp?.int32Value > track2.timestamp?.int32Value
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tracksData.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        cell.feedController = self
        cell.track = tracksData[(indexPath as NSIndexPath).item]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 180)
	}
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MusicPlayer.playSong(tracksData[(indexPath as NSIndexPath).item])
    }
}









