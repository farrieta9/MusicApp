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
		seg.insertSegment(withTitle: "Music", at: 0, animated: true)
		seg.insertSegment(withTitle: "People", at: 1, animated: true)
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
		segmentControl.topAnchor.constraint(equalTo: topAnchor, constant: 68).isActive = true
		segmentControl.widthAnchor.constraint(equalTo: widthAnchor, constant: -8).isActive = true
		segmentControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
		segmentControl.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
		
		tableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8).isActive = true
		tableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		tableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 4).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
