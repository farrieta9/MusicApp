//
//  AppTabBarController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
	
	let playerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.blueColor()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.hidden = false
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let layout = UICollectionViewFlowLayout()
		let feedController = FeedController(collectionViewLayout: layout)
		let feedNavigationController = UINavigationController(rootViewController: feedController)
		feedNavigationController.tabBarItem.image = UIImage(named: "activity_feed")
		feedNavigationController.tabBarItem.title = "Feed"
		
		let searchController = SearchController()
		let searchNavigationController = UINavigationController(rootViewController: searchController)
		searchNavigationController.tabBarItem.title = "Search"
		
		let userController = UserController()
		let userNavigationController = UINavigationController(rootViewController: userController)
		userNavigationController.tabBarItem.title = "Profile"
		userNavigationController.tabBarItem.image = UIImage(named: "neutral_user")
		
		viewControllers = [feedNavigationController, searchNavigationController, userNavigationController]
		
		
		view.addSubview(playerView)
		setUpContraints()
	}
	
	private func setUpContraints() {
		// Need x, y, width, and height
		playerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		playerView.centerYAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -70).active = true
		playerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		playerView.heightAnchor.constraintEqualToConstant(50).active = true
	}
}

