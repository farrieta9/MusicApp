//
//  SearchView.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        return view
    }()
	
	let tableView: UITableView = {
		let tv = UITableView()
		tv.translatesAutoresizingMaskIntoConstraints = false
		return tv
	}()
	
	let segmentControl: UISegmentedControl = {
		let seg = UISegmentedControl()
		seg.translatesAutoresizingMaskIntoConstraints = false
		seg.insertSegmentWithTitle("Music", atIndex: 0, animated: true)
		seg.insertSegmentWithTitle("People", atIndex: 1, animated: true)
        seg.selectedSegmentIndex = 0
		return seg
	}()
    
  	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setUpView()
	}

	func setUpView() {
		addSubview(segmentControl)
		addSubview(tableView)
        addSubview(separatorView)
		segmentControl.topAnchor.constraintEqualToAnchor(topAnchor, constant: 68).active = true
		segmentControl.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: -8).active = true
		segmentControl.heightAnchor.constraintEqualToConstant(32).active = true
		segmentControl.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
		
		tableView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
		tableView.topAnchor.constraintEqualToAnchor(segmentControl.bottomAnchor, constant: 8).active = true
		tableView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
		tableView.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        
        separatorView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        separatorView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
        separatorView.heightAnchor.constraintEqualToConstant(1).active = true
        separatorView.topAnchor.constraintEqualToAnchor(segmentControl.bottomAnchor, constant: 4).active = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
