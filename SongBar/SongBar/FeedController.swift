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
	
	private let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
        checkIfUserIsSignedIn()
		navigationItem.title = "Feed"
		collectionView?.backgroundColor = UIColor.whiteColor()
		collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
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
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! FeedCell
		
		cell.thumbnailImageView.image = UIImage(named: "default_profile")
		cell.userImageView.image = UIImage(named: "default_profile")
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(view.frame.width, 200)
	}
}