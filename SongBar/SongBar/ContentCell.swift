//
//  ContentCell.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
//            spotifyIconImageView.hidden = true
            thumbnailImageView.layer.cornerRadius = 25
            textLabel?.text = user.username
            detailTextLabel?.text = user.email
            
            if let imageUrl = user.imageUrl {
                thumbnailImageView.loadImageUsingURLString(imageUrl)
            } else {
                thumbnailImageView.loadImageUsingURLString("")
            }
        }
    }
    
    var track: SpotifyTrack? {
        didSet {
            guard let track = track else {
                return
            }
            thumbnailImageView.layer.cornerRadius = 0
//            spotifyIconImageView.hidden = false
            textLabel?.text = track.title
            detailTextLabel?.text = track.artist
            thumbnailImageView.loadImageUsingURLString(track.imageUrl)
        }
    }

	override func layoutSubviews() {
		super.layoutSubviews()
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
		
		textLabel?.frame = CGRect(x: thumbnailImageView.frame.width + 16, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
		
		detailTextLabel?.frame = CGRect(x: thumbnailImageView.frame.width + 16, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
	}

	let thumbnailImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "default_profile.png")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
		return imageView
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
    
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		
		addSubview(thumbnailImageView)
//        addSubview(spotifyIconImageView)
		
		// need x, y, width, height
		thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
		thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		thumbnailImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		thumbnailImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        The Spotify icon should never be smaller than 21px in digital or 6mm in print.
//        spotifyIconImageView.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -8).active = true
//        spotifyIconImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -8).active = true
//        spotifyIconImageView.widthAnchor.constraintEqualToConstant(23).active = true
//        spotifyIconImageView.heightAnchor.constraintEqualToConstant(23).active = true
        
        
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
