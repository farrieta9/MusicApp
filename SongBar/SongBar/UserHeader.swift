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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 39
        imageView.clipsToBounds = true
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
        seg.insertSegment(withTitle: "Posts", at: 0, animated: true)
        seg.insertSegment(withTitle: "Fans", at: 1, animated: true)
        seg.insertSegment(withTitle: "Following", at: 2, animated: true)
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Follow", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.rgb(50, green: 50, blue: 100), for: UIControlState())
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.isHidden = true
        return button
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(200, green: 200, blue: 200)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    fileprivate func setUpView() {
        addSubview(pictureView)
        addSubview(usernameLabel)
        addSubview(fullnameLabel)
        addSubview(segmentControl)
        addSubview(followButton)
        addSubview(seperatorView)
        
        // Setup contraints
        pictureView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        pictureView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        pictureView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        pictureView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        
        usernameLabel.centerYAnchor.constraint(equalTo: pictureView.centerYAnchor, constant: -16).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: pictureView.rightAnchor, constant: 8).isActive = true
        
        fullnameLabel.centerYAnchor.constraint(equalTo: pictureView.centerYAnchor, constant: 16).isActive = true
        fullnameLabel.leftAnchor.constraint(equalTo: pictureView.rightAnchor, constant: 8).isActive = true
        
        segmentControl.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        segmentControl.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 16).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: widthAnchor, constant: -8).isActive = true
        
        followButton.topAnchor.constraint(equalTo: pictureView.topAnchor).isActive = true
        followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








