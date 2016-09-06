//
//  ViewController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class FeedController: UICollectionViewController {
	
	private let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Feed"
		collectionView?.backgroundColor = UIColor.whiteColor()
		collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! FeedCell
		
//		cell.backgroundColor = UIColor.redColor()
		cell.thumbnailImageView.image = UIImage(named: "default_profile")
		cell.userImageView.image = UIImage(named: "default_profile")
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(view.frame.width, 200)
	}
}
