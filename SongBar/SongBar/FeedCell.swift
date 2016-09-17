//
//  FeedCell.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    var track: SpotifyTrack? {
        didSet {
            guard let track = track else {
                return
            }
            
            titleLabel.text = track.title
            subTitleLabel.text = track.artist
            commentButton.setTitle(track.comment, for: UIControlState())
            fetchDonorByUid(track.donor!)
            thumbnailImageView.loadImageUsingURLString(track.imageUrl)
        }
    }
    
    fileprivate func fetchDonorByUid(_ uid: String) {
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.setValuesForKeys(result)
            
            self.usernameLabel.text = user.username
            if let imageUrl = user.imageUrl {
                self.userImageView.loadImageUsingURLString(imageUrl)
            } else {
                self.userImageView.loadImageUsingURLString("")
            }
            
            
        }, withCancel: nil)
    }
	
	let thumbnailImageView: UIImageView	= {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = UIViewContentMode.scaleAspectFit
		return imageView
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Some song"
		label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}()
	
	let subTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Some artist name here"
		label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
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
		imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
		return imageView
	}()
	
	let trackView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let descriptionView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setTitle("A really nice comment button", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpView()
        
        commentButton.addTarget(self, action: #selector(self.handleComment), for: .touchUpInside)
	}
    
    func handleComment() {
        guard let parent = feedController, let commentReference = track?.commentReference else {
            return
        }
        
        let commentController = CommentController()
        commentController.commentReference = commentReference
        parent.navigationController?.pushViewController(commentController, animated: true)
    }
    
	func setUpView() {
		addSubview(trackView)
		addSubview(descriptionView)
		
		// x, y, width, height
		trackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		trackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		trackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		trackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
		
		descriptionView.topAnchor.constraint(equalTo: trackView.bottomAnchor).isActive = true
		descriptionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		descriptionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
		
		trackView.addSubview(thumbnailImageView)
		trackView.addSubview(titleLabel)
		trackView.addSubview(subTitleLabel)
		trackView.addSubview(separateView)
		
		thumbnailImageView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor).isActive = true
		thumbnailImageView.leftAnchor.constraint(equalTo: trackView.leftAnchor, constant: 8).isActive = true
		thumbnailImageView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: 1/4).isActive = true
		thumbnailImageView.heightAnchor.constraint(equalTo: trackView.heightAnchor, constant: -8).isActive = true
		
		titleLabel.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor).isActive = true
		titleLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 8).isActive = true
		
		subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
		subTitleLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 8).isActive = true
		
		separateView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		separateView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separateView.topAnchor.constraint(equalTo: trackView.topAnchor).isActive = true
		separateView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		
		descriptionView.addSubview(userImageView)
		descriptionView.addSubview(usernameLabel)
		descriptionView.addSubview(commentButton)
		
		userImageView.leftAnchor.constraint(equalTo: descriptionView.leftAnchor, constant: 8).isActive = true
		userImageView.centerYAnchor.constraint(equalTo: descriptionView.centerYAnchor).isActive = true
		userImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
		userImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
		
		usernameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 0).isActive = true
		usernameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
		
		commentButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: 8).isActive = true
		commentButton.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
