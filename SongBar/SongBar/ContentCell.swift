//
//  ContentCell.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {

	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		textLabel?.frame = CGRectMake(thumbnailImageView.frame.width + 16, textLabel!.frame.origin.y, textLabel!.frame.width, textLabel!.frame.height)
		
		detailTextLabel?.frame = CGRectMake(thumbnailImageView.frame.width + 16, detailTextLabel!.frame.origin.y, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
	}
//
	let thumbnailImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "default_profile.png")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .ScaleAspectFill
		imageView.layer.cornerRadius = 25
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
		
		addSubview(thumbnailImageView)
		
		// need x, y, width, height
		thumbnailImageView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 8).active = true
		thumbnailImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
		thumbnailImageView.widthAnchor.constraintEqualToConstant(50).active = true
		thumbnailImageView.heightAnchor.constraintEqualToConstant(50).active = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
