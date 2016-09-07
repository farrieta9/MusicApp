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
//        createSearchBarInNavigationBar()
	}
	
	func setUpSearchView() {
		view.addSubview(searchView)
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        
		searchView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		searchView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
		searchView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		searchView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
		
		searchView.tableView.registerClass(ContentCell.self, forCellReuseIdentifier: cellId)
		
		searchView.tableView.dataSource = self
		searchView.tableView.delegate = self
	}
//    
//    var searchBar: UISearchBar!
//    
//    func createSearchBarInNavigationBar() {
//        searchBar = UISearchBar()
//        searchBar.showsCancelButton = false
//        searchBar.placeholder = "Search for music here"
//        searchBar.delegate = self
//        searchBar.autocorrectionType = .No
//        searchBar.autocapitalizationType = .None
//        searchBar.returnKeyType = .Done
//        self.navigationItem.titleView = searchBar
//    }
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.showsCancelButton = false
        bar.placeholder = "Search here..."
        bar.autocorrectionType = .No
        bar.autocapitalizationType = .None
        bar.returnKeyType = .Done
        return bar
    }()
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

//extension SearchController: UISearchBarDelegate {
//    
//
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        searchBar.showsCancelButton = true
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.showsCancelButton = false
//        searchBar.text = ""
//    }
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.showsCancelButton = true
//    }
//}

extension SearchController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}