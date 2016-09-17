//
//  CommentCell.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/15/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var comment: Comment? {
        didSet {
            
            guard let comment = comment, let user = comment.user else {
                return
            }
            
            commentLabel.text = comment.comment
            usernameLabel.text = user.username
            
            if let dateAsDouble = Double(comment.timestamp!) {
                let timestamp = Date(timeIntervalSince1970: dateAsDouble)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd"
                timestampLabel.text = timestamp.getElapsedInterval()
            }
            
            if let imageUrl = user.imageUrl {
                pictureView.loadImageUsingURLString(imageUrl)
            }
        }
    }
    
    let pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
        
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4d"
        label.isEnabled = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(pictureView)
        addSubview(usernameLabel)
        addSubview(commentLabel)
        addSubview(timestampLabel)
        
        setUpViews()
    }
    
    fileprivate func setUpViews() {
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
        pictureView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        pictureView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pictureView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pictureView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: pictureView.rightAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        commentLabel.leftAnchor.constraint(equalTo: pictureView.rightAnchor, constant: 8).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        commentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8).isActive = true
        commentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timestampLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timestampLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -16).isActive = true
        timestampLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setCellContent(user: User, comment: String, date: String) {
////        if let image = user.imageString {
////            pictureView.loadImageUsingURLString(image)
////        }
////        
////        usernameLabel.text = user.username
////        commentLabel.text = comment
////        
////        if let dateAsDouble = Double(date) {
////            let timestamp = NSDate(timeIntervalSince1970: dateAsDouble)
////            let dateFormatter = NSDateFormatter()
////            dateFormatter.dateFormat = "MM/dd"
////            timestampLabel.text = timestamp.getElapsedInterval()
////        }
//    }
}
