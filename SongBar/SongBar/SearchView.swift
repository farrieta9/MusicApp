//
//  SearchView.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class SearchView: UIView {
	
	let tableView: UITableView = {
		let tv = UITableView()
		tv.translatesAutoresizingMaskIntoConstraints = false
		return tv
	}()
	
	let segmentControl: UISegmentedControl = {
		let seg = UISegmentedControl()
		seg.translatesAutoresizingMaskIntoConstraints = false
		seg.insertSegmentWithTitle("One", atIndex: 0, animated: true)
		seg.insertSegmentWithTitle("Two", atIndex: 1, animated: true)
		return seg
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setUpView()
	}

	func setUpView() {
		addSubview(segmentControl)
		addSubview(tableView)
		
		segmentControl.topAnchor.constraintEqualToAnchor(topAnchor, constant: 72).active = true
		segmentControl.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: -16).active = true
		segmentControl.heightAnchor.constraintEqualToConstant(32).active = true
		segmentControl.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
		
		
		tableView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
		tableView.topAnchor.constraintEqualToAnchor(segmentControl.bottomAnchor, constant: 8).active = true
		tableView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
		tableView.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
