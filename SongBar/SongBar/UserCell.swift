//
//  UserCell.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/8/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class UserHeader: UIView {
    
    let pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "default_profile")
        imageView.image = image
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "username"
        return label
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "fullname"
        return label
    }()
    
    let segmentControl: UISegmentedControl = {
        let seg = UISegmentedControl()
        seg.insertSegmentWithTitle("Posts", atIndex: 0, animated: true)
        seg.insertSegmentWithTitle("Fans", atIndex: 1, animated: true)
        seg.insertSegmentWithTitle("Following", atIndex: 2, animated: true)
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Follow", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clearColor()
        button.setTitleColor(UIColor.rgb(50, green: 50, blue: 100), forState: .Normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    private func setUpView() {
        addSubview(pictureView)
        addSubview(usernameLabel)
        addSubview(fullnameLabel)
        addSubview(segmentControl)
        addSubview(followButton)
        
        // Setup contraints
        pictureView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 16).active = true
        pictureView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 16).active = true
        pictureView.widthAnchor.constraintEqualToConstant(78).active = true
        pictureView.heightAnchor.constraintEqualToConstant(78).active = true
        
        usernameLabel.centerYAnchor.constraintEqualToAnchor(pictureView.centerYAnchor, constant: -16).active = true
        usernameLabel.leftAnchor.constraintEqualToAnchor(pictureView.rightAnchor, constant: 8).active = true
        
        fullnameLabel.centerYAnchor.constraintEqualToAnchor(pictureView.centerYAnchor, constant: 16).active = true
        fullnameLabel.leftAnchor.constraintEqualToAnchor(pictureView.rightAnchor, constant: 8).active = true
        
        segmentControl.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
        segmentControl.topAnchor.constraintEqualToAnchor(pictureView.bottomAnchor, constant: 16).active = true
        segmentControl.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: -8).active = true
        
        followButton.centerYAnchor.constraintEqualToAnchor(pictureView.centerYAnchor, constant: 0).active = true
        followButton.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -16).active = true
        followButton.widthAnchor.constraintEqualToConstant(100).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








