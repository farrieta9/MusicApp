//
//  SettingsCell.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/9/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        return view
    }()
    
    override var highlighted: Bool {
        didSet {
            backgroundColor = highlighted ? UIColor.darkGrayColor() : UIColor.whiteColor()
            nameLabel.textColor = highlighted ? UIColor.whiteColor() : UIColor.blackColor()
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    func setUpView() {
        addSubview(nameLabel)
        addSubview(separatorView)
        nameLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        nameLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        
        separatorView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        separatorView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
        separatorView.topAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        separatorView.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}