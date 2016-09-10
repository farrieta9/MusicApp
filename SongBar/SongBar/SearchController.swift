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

    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicator.clipsToBounds = true
        indicator.color = UIColor(white: 0.3, alpha: 0.9)
        indicator.layer.cornerRadius = 5
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var peopleData = [User]()
    var musicData = [SpotifyTrack]()
    enum SearchContentType {
        case Music
        case People
    }
    var searchContent: SearchContentType = .Music
	
	private let cellId = "cellId"
    var timer: NSTimer? = nil
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
        view.addSubview(indicator)
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        
		searchView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		searchView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
		searchView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		searchView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        indicator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        indicator.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        indicator.widthAnchor.constraintEqualToConstant(50).active = true
        indicator.heightAnchor.constraintEqualToConstant(50).active = true
		
		searchView.tableView.registerClass(ContentCell.self, forCellReuseIdentifier: cellId)
		
		searchView.tableView.dataSource = self
		searchView.tableView.delegate = self
        searchView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
        
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
        
        attemptReloadTable()
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
    
    func searchBarTextDidPause(timer: NSTimer) {
        // Custom method
        guard let text = searchBar.text?.lowercaseString else {
            print("searchBarTextDidPause() failed")
            return
        }
        
        if text.characters.count == 0 {
            clearTable()
            return
        }

        switch searchContent {
        case .Music:
            searchForMusic(text)
        case .People:
            searchForPeople(text)
        }
    }
    
    private func searchForPeople(searchText: String) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users").queryOrderedByChild("username").queryStartingAtValue(searchText).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            self.peopleData.removeAll()
            
            guard let result = snapshot.value as? [String: AnyObject] else {
                return
            }

            for (key, value) in result {
                if uid != key { // Do not display signed in user
                    let user = User()
                    user.uid = key
                    user.email = value["email"] as? String
                    user.username = value["username"] as? String
                    
                    if let imageUrl = value["imageUrl"] as? String {
                        user.imageUrl = imageUrl
                    }
                    
                    self.peopleData.append(user)
                    self.attemptReloadTable()
                }
            }
            
        }, withCancelBlock: nil)
    }
    
    func showUserControllerForUser(user: User) {
        let userController = UserController()
        userController.user = user
        userController.checkIfFollowing()
        navigationController?.pushViewController(userController, animated: true)
    }
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.searchView.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    func clearTable() -> Void {
        peopleData.removeAll()
        attemptReloadTable()
    }
}

extension SearchController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchContent {
        case .Music:
            return musicData.count
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
            cell.track = musicData[indexPath.row]
        case .People:
            cell.user = peopleData[indexPath.row]
        }
        
		return cell
	}
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        switch searchContent {
        case .Music:
            showShareControllerWithTrack(musicData[indexPath.row])
        case .People:
            let selectedUser = peopleData[indexPath.row]
            showUserControllerForUser(selectedUser)
        }
    }
    
    func searchForMusic(searchText: String) {
        SpotifyApi.search(searchText) {
            (tracks) in dispatch_async(dispatch_get_main_queue()) {
                self.musicData = tracks
                self.attemptReloadTable()
            }
        }
    }
    
    func showShareControllerWithTrack(track: SpotifyTrack) {
        let shareController = ShareController()
        shareController.track = track
        navigationController?.pushViewController(shareController, animated: true)
    }
}

extension SearchController: UITableViewDelegate {
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 72
	}
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let playAction = UITableViewRowAction()
        
        return [playAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        switch searchContent {
        case .Music:
            MusicPlayer.playSong(musicData[indexPath.row])
            self.searchBar.resignFirstResponder()
        default:
            return
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        indicator.startAnimating()
        
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