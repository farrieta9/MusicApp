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
        view.backgroundColor = UIColor.rgb(225, green: 225, blue: 225)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.hidden = true
		return view
	}()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "pause")
        button.setImage(image, forState: .Normal)
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "delete")
        button.setImage(image, forState: .Normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some track name"
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Artist name"
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    let spotifyIconImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "spotify_icon_cmyk_green")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
	
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
        playerView.addSubview(spotifyIconImageView)
		setUpContraints()
	}
    
	private func setUpContraints() {
		// Need x, y, width, and height
		playerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		playerView.centerYAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -70).active = true
		playerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		playerView.heightAnchor.constraintEqualToConstant(50).active = true
        
        playPauseButton.centerYAnchor.constraintEqualToAnchor(playerView.centerYAnchor).active = true
        playPauseButton.leftAnchor.constraintEqualToAnchor(playerView.leftAnchor, constant: 8).active = true
        
        stopButton.centerYAnchor.constraintEqualToAnchor(playerView.centerYAnchor).active = true
        stopButton.rightAnchor.constraintEqualToAnchor(playerView.rightAnchor, constant: -8).active = true
        
        titleLabel.leftAnchor.constraintEqualToAnchor(playPauseButton.rightAnchor, constant: 8).active = true
        titleLabel.centerYAnchor.constraintEqualToAnchor(playPauseButton.topAnchor, constant: 2).active = true
        
        detailLabel.leftAnchor.constraintEqualToAnchor(playPauseButton.rightAnchor, constant: 8).active = true
        detailLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: 4).active = true
        
        spotifyIconImageView.rightAnchor.constraintEqualToAnchor(stopButton.leftAnchor, constant: -4).active = true
        spotifyIconImageView.bottomAnchor.constraintEqualToAnchor(playerView.bottomAnchor, constant: -4).active = true
        spotifyIconImageView.widthAnchor.constraintEqualToConstant(21).active = true
        spotifyIconImageView.heightAnchor.constraintEqualToConstant(21).active = true
	}
    
    private func setUpMusicPlayer() {
        MusicPlayer.playView = playerView
        MusicPlayer.titleLabel = titleLabel
        MusicPlayer.detailLabel = detailLabel
        MusicPlayer.playButton = playPauseButton
        stopButton.addTarget(self, action: #selector(self.onStopButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        playPauseButton.addTarget(self, action: #selector(self.onPlayButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onStopButton(sender: UIButton) {
        guard let audioPlayer = MusicPlayer.audioPlay else {
            return
        }
        
        playerView.hidden = true
        audioPlayer.pause()
    }
    
    func onPlayButton(sender: UIButton) {
        guard let audioPlayer = MusicPlayer.audioPlay else {
            return
        }
        
        switch MusicPlayer.musicStatus {
        case .Pause:
            MusicPlayer.musicStatus = .Play
            let image = UIImage(named: "pause")
            sender.setImage(image, forState: .Normal)
            audioPlayer.play()
            
        case .Play:
            MusicPlayer.musicStatus = .Pause
            let image = UIImage(named: "play")
            sender.setImage(image, forState: .Normal)
            audioPlayer.pause()
        }
        
    }
}















