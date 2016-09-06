//
//  SearchController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
	
	private let cellId = "cellId"
	
	let searchView: SearchView = {
		let sv = SearchView()
		sv.translatesAutoresizingMaskIntoConstraints = false
		sv.backgroundColor = UIColor.whiteColor()
		return sv
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpSearchView()
	}
	
	func setUpSearchView() {
		view.addSubview(searchView)
		searchView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		searchView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
		searchView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		searchView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
		
		searchView.tableView.registerClass(ContentCell.self, forCellReuseIdentifier: cellId)
		
		searchView.tableView.dataSource = self
		searchView.tableView.delegate = self
		
	}
}

extension SearchController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ContentCell
		cell.detailTextLabel?.text = "Some detail"
		cell.textLabel?.text = "Some fancy text"
		return cell
	}

}

extension SearchController: UITableViewDelegate {
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 72
	}
}