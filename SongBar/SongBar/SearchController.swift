//
//  SearchController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UIViewController {
    
    var peopleData = [User]()
    enum SearchContentType {
        case Music
        case People
    }
    var searchContent: SearchContentType = .Music
	
	private let cellId = "cellId"
    var timer: NSTimer? = nil
    var indicator = UIActivityIndicatorView()
	let searchView: SearchView = {
		let sv = SearchView()
		sv.translatesAutoresizingMaskIntoConstraints = false
		sv.backgroundColor = UIColor.whiteColor()
		return sv
	}()
    
    
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpSearchView()
        activityIndicator()
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
        
        searchView.segmentControl.addTarget(self, action: #selector(handleSegmentControl), forControlEvents: .ValueChanged)
	}
    
    func handleSegmentControl() {
        switch searchView.segmentControl.selectedSegmentIndex {
        case 0:
            searchContent = .Music
        case 1:
            searchContent = .People
        default:
            break
        }
    }

    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.showsCancelButton = false
        bar.placeholder = "Search here..."
        bar.autocorrectionType = .No
        bar.autocapitalizationType = .None
        bar.returnKeyType = .Done
        return bar
    }()
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.center = self.view.center
        indicator.clipsToBounds = true
        self.view.addSubview(indicator)
    }
    
    func searchBarTextDidPause(timer: NSTimer) {
        // Custom method
        guard let text = searchBar.text?.lowercaseString else {
            print("searchBarTextDidPause() failed")
            return
        }
        
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        
        if text.characters.count == 0 {
            clearTable()
            return
        }
        
        
        switch searchContent {
        case .Music:
//            searchForMusic(text)
            print("searchForMusic")
        case .People:
            searchForPeople(text)
        }
    }
    
    private func searchForPeople(searchText: String) {
        FIRDatabase.database().reference().child("users").queryOrderedByChild("username").queryStartingAtValue(searchText).observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
            
            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            
            user.uid = snapshot.key
            user.email = result["email"] as? String
            user.username = result["username"] as? String
            
            if let imageUrl = result["imageUrl"] as? String {
                user.imageUrl = imageUrl
            }
            
            self.peopleData.append(user)
            self.attemptReloadTable()
            
            
        }, withCancelBlock: nil)
    }
    
    func showUserControllerForUser(user: User) {
        let userController = UserController()
        userController.user = user
        navigationController?.pushViewController(userController, animated: true)
    }
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.searchView.tableView.reloadData()
        }
    }
    
    func clearTable() -> Void {
        peopleData.removeAll()
        dispatch_async(dispatch_get_main_queue()) {
            self.searchView.tableView.reloadData()
        }
    }
}

extension SearchController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchContent {
        case .Music:
            return 0
        case .People:
            return peopleData.count
        }
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ContentCell
		cell.detailTextLabel?.text = "Some detail"
		cell.textLabel?.text = "Some fancy text"
        
        switch searchContent {
        case .Music:
            cell.detailTextLabel?.text = "Some detail"
            cell.textLabel?.text = "Some fancy text"
        case .People:
            cell.user = peopleData[indexPath.row]
        }
        
		return cell
	}
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedUser = peopleData[indexPath.row]
        
        showUserControllerForUser(selectedUser)
    }
    
    
}

extension SearchController: UITableViewDelegate {
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 72
	}
}

extension SearchController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.whiteColor()
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: #selector(self.searchBarTextDidPause(_:)), userInfo: searchBar.text, repeats: false)
        
        return true
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        clearTable()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}