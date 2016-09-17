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
		view.backgroundColor = UIColor.blue
        view.backgroundColor = UIColor.rgb(225, green: 225, blue: 225)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.isHidden = true
		return view
	}()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "pause")
        button.setImage(image, for: UIControlState())
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "delete")
        button.setImage(image, for: UIControlState())
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some track name"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Artist name"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
//    let spotifyIconImageView: UIImageView = {
//        let imageView = UIImageView()
//        let image = UIImage(named: "spotify_icon_cmyk_green")
//        imageView.image = image
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .ScaleAspectFit
//        imageView.clipsToBounds = true
//        return imageView
//    }()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
		let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
		let feedController = FeedController(collectionViewLayout: layout)
		let feedNavigationController = UINavigationController(rootViewController: feedController)
		feedNavigationController.tabBarItem.image = UIImage(named: "activity_feed")
		feedNavigationController.tabBarItem.title = "Feed"
		
		let searchController = SearchController()
		let searchNavigationController = UINavigationController(rootViewController: searchController)
		searchNavigationController.tabBarItem.title = "Search"
        searchNavigationController.tabBarItem.image = UIImage(named: "Search-50")
		
		let userController = UserController()
		let userNavigationController = UINavigationController(rootViewController: userController)
		userNavigationController.tabBarItem.title = "Profile"

		userNavigationController.tabBarItem.image = UIImage(named: "neutral_user")
		
		viewControllers = [feedNavigationController, searchNavigationController, userNavigationController]
        
        setUpMusicPlayer()
		
		view.addSubview(playerView)
        playerView.addSubview(playPauseButton)
        playerView.addSubview(stopButton)
        playerView.addSubview(titleLabel)
        playerView.addSubview(detailLabel)
//        playerView.addSubview(spotifyIconImageView)
		setUpContraints()
	}
    
	fileprivate func setUpContraints() {
		// Need x, y, width, and height
		playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		playerView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
		playerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		playerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        playPauseButton.centerYAnchor.constraint(equalTo: playerView.centerYAnchor).isActive = true
        playPauseButton.leftAnchor.constraint(equalTo: playerView.leftAnchor, constant: 8).isActive = true
        
        stopButton.centerYAnchor.constraint(equalTo: playerView.centerYAnchor).isActive = true
        stopButton.rightAnchor.constraint(equalTo: playerView.rightAnchor, constant: -8).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: playPauseButton.rightAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: playPauseButton.topAnchor, constant: 2).isActive = true
        
        detailLabel.leftAnchor.constraint(equalTo: playPauseButton.rightAnchor, constant: 8).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        
//        spotifyIconImageView.rightAnchor.constraintEqualToAnchor(stopButton.leftAnchor, constant: -4).active = true
//        spotifyIconImageView.bottomAnchor.constraintEqualToAnchor(playerView.bottomAnchor, constant: -4).active = true
//        spotifyIconImageView.widthAnchor.constraintEqualToConstant(21).active = true
//        spotifyIconImageView.heightAnchor.constraintEqualToConstant(21).active = true
	}
    
    fileprivate func setUpMusicPlayer() {
        MusicPlayer.playView = playerView
        MusicPlayer.titleLabel = titleLabel
        MusicPlayer.detailLabel = detailLabel
        MusicPlayer.playButton = playPauseButton
        stopButton.addTarget(self, action: #selector(self.onStopButton(_:)), for: UIControlEvents.touchUpInside)
        playPauseButton.addTarget(self, action: #selector(self.onPlayButton(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func onStopButton(_ sender: UIButton) {
        guard let audioPlayer = MusicPlayer.audioPlay else {
            return
        }
        
        playerView.isHidden = true
        audioPlayer.pause()
    }
    
    func onPlayButton(_ sender: UIButton) {
        guard let audioPlayer = MusicPlayer.audioPlay else {
            return
        }
        
        switch MusicPlayer.musicStatus {
        case .pause:
            MusicPlayer.musicStatus = .play
            let image = UIImage(named: "pause")
            sender.setImage(image, for: UIControlState())
            audioPlayer.play()
            
        case .play:
            MusicPlayer.musicStatus = .pause
            let image = UIImage(named: "play")
            sender.setImage(image, for: UIControlState())
            audioPlayer.pause()
        }
        
    }
}















