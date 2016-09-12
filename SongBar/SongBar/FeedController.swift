//
//  ViewController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class FeedController: UICollectionViewController {
	
    var timer: NSTimer? = nil
    var tracksData = [SpotifyTrack]()
	private let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
        checkIfUserIsSignedIn()
		navigationItem.title = "Feed"
		collectionView?.backgroundColor = UIColor.whiteColor()
		collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        observeFeed()
	}
    
    func checkIfUserIsSignedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // To remove error 'Unbalanced calls to begin end appearance transitions for UINavCtrl
            performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                if let results = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = results["username"] as? String
                }
                
            }, withCancelBlock: nil)
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
        presentViewController(navController, animated: true, completion: nil)
    }
    
    private func observeFeed() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("songs-shared").child(uid).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let track = SpotifyTrack()
            track.setValuesForKeysWithDictionary(result)
            track.timestamp = Int(snapshot.key)
            self.tracksData.append(track)
            
            self.attemptReloadTable()
            
            
        }, withCancelBlock: nil)
    }
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        
        self.tracksData.sortInPlace { (track1, track2) -> Bool in
            // Decending order
            return track1.timestamp?.intValue > track2.timestamp?.intValue
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView?.reloadData()
        }
    }
    
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tracksData.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! FeedCell
        
        cell.track = tracksData[indexPath.item]
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(view.frame.width, 180)
	}
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        MusicPlayer.playSong(tracksData[indexPath.item])
    }
}









