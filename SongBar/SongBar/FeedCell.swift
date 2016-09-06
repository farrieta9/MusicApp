//
//  FeedCell.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
	
	let thumbnailImageView: UIImageView	= {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		return imageView
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Some song"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let subTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Some artist name here"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let separateView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor.rgb(220, green: 220, blue: 220)
		return view
	}()
	
	let userImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		return imageView
	}()
	
	let trackView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor.greenColor()
		return view
	}()
	
	let descriptionView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
//		view.backgroundColor = UIColor.blueColor()
		return view
	}()
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let commentLabel: UILabel = {
		let label = UILabel()
		label.text = "A really nice comment"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpView()
	}
	
	func setUpView() {
		addSubview(trackView)
		addSubview(descriptionView)
		
		// x, y, width, height
		trackView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		trackView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
		trackView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
		trackView.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 2/3).active = true
		
		descriptionView.topAnchor.constraintEqualToAnchor(trackView.bottomAnchor).active = true
		descriptionView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
		descriptionView.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 1/3).active = true
		
		trackView.addSubview(thumbnailImageView)
		trackView.addSubview(titleLabel)
		trackView.addSubview(subTitleLabel)
		trackView.addSubview(separateView)
		
		thumbnailImageView.centerYAnchor.constraintEqualToAnchor(trackView.centerYAnchor).active = true
		thumbnailImageView.leftAnchor.constraintEqualToAnchor(trackView.leftAnchor, constant: 8).active = true
		thumbnailImageView.widthAnchor.constraintEqualToAnchor(trackView.widthAnchor, multiplier: 1/4).active = true
		thumbnailImageView.heightAnchor.constraintEqualToAnchor(trackView.heightAnchor, constant: -8).active = true
		
		titleLabel.centerYAnchor.constraintEqualToAnchor(thumbnailImageView.centerYAnchor).active = true
		titleLabel.leftAnchor.constraintEqualToAnchor(thumbnailImageView.rightAnchor, constant: 8).active = true
		
		subTitleLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: 8).active = true
		subTitleLabel.leftAnchor.constraintEqualToAnchor(thumbnailImageView.rightAnchor, constant: 8).active = true
		
		separateView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
		separateView.heightAnchor.constraintEqualToConstant(1).active = true
		separateView.topAnchor.constraintEqualToAnchor(trackView.bottomAnchor).active = true
		separateView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
		
		descriptionView.addSubview(userImageView)
		descriptionView.addSubview(usernameLabel)
		descriptionView.addSubview(commentLabel)
		
		userImageView.leftAnchor.constraintEqualToAnchor(descriptionView.leftAnchor, constant: 8).active = true
		userImageView.centerYAnchor.constraintEqualToAnchor(descriptionView.centerYAnchor).active = true
		userImageView.heightAnchor.constraintEqualToConstant(48).active = true
		userImageView.widthAnchor.constraintEqualToConstant(48).active = true
		
		usernameLabel.topAnchor.constraintEqualToAnchor(userImageView.topAnchor, constant: 0).active = true
		usernameLabel.leftAnchor.constraintEqualToAnchor(userImageView.rightAnchor, constant: 8).active = true
		
		commentLabel.centerYAnchor.constraintEqualToAnchor(userImageView.centerYAnchor, constant: 8).active = true
		commentLabel.leftAnchor.constraintEqualToAnchor(userImageView.rightAnchor, constant: 8).active = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
