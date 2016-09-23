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
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
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
        case music
        case people
    }
    var searchContent: SearchContentType = .music
	
	fileprivate let cellId = "cellId"
    var timer: Timer? = nil
	let searchView: SearchView = {
		let sv = SearchView()
		sv.translatesAutoresizingMaskIntoConstraints = false
		sv.backgroundColor = UIColor.white
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
        
		searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		searchView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		searchView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		searchView.tableView.register(ContentCell.self, forCellReuseIdentifier: cellId)
		
		searchView.tableView.dataSource = self
		searchView.tableView.delegate = self
        searchView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
        
        searchView.segmentControl.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
	}
    
    func handleSegmentControl() {
        switch searchView.segmentControl.selectedSegmentIndex {
        case 0:
            searchContent = .music
        case 1:
            searchContent = .people
        default:
            break
        }
        
        attemptReloadTable()
    }

    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.showsCancelButton = false
        bar.placeholder = "Search here..."
        bar.autocorrectionType = .no
        bar.autocapitalizationType = .none
        bar.returnKeyType = .done
        return bar
    }()
    
    func searchBarTextDidPause(_ timer: Timer) {
        // Custom method
        guard let text = searchBar.text?.lowercased() else {
            print("searchBarTextDidPause() failed")
            return
        }
        
        if text.characters.count == 0 {
            clearTable()
            return
        }

        switch searchContent {
        case .music:
            searchForMusic(text)
        case .people:
            searchForPeople(text)
        }
    }
    
    fileprivate func searchForPeople(_ searchText: String) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users").queryOrdered(byChild: "username").queryStarting(atValue: searchText).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
            
        }, withCancel: nil)
    }
    
    func showUserControllerForUser(_ user: User) {
        let userController = UserController()
        userController.user = user
        userController.checkIfFollowing()
        navigationController?.pushViewController(userController, animated: true)
    }
    
    fileprivate func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        DispatchQueue.main.async { 
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
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchContent {
        case .music:
            return musicData.count
        case .people:
            return peopleData.count
        }
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContentCell
		cell.detailTextLabel?.text = "Some detail"
		cell.textLabel?.text = "Some fancy text"
        
        switch searchContent {
        case .music:
            cell.track = musicData[(indexPath as NSIndexPath).row]
        case .people:
            cell.user = peopleData[(indexPath as NSIndexPath).row]
        }
        
		return cell
	}
    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        switch searchContent {
        case .music:
            showShareControllerWithTrack(musicData[(indexPath as NSIndexPath).row])
        case .people:
            let selectedUser = peopleData[(indexPath as NSIndexPath).row]
            showUserControllerForUser(selectedUser)
        }
    }
    
    func searchForMusic(_ searchText: String) {
        SpotifyApi.search(searchText) {
            (tracks) in DispatchQueue.main.async {
                self.musicData = tracks
                self.attemptReloadTable()
            }
        }
    }
    
    func showShareControllerWithTrack(_ track: SpotifyTrack) {
        let shareController = ShareController()
        shareController.track = track
        navigationController?.pushViewController(shareController, animated: true)
    }
}

extension SearchController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let playAction = UITableViewRowAction()
        
        return [playAction]
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        switch searchContent {
        case .music:
            MusicPlayer.playSong(musicData[(indexPath as NSIndexPath).row])
            self.searchBar.resignFirstResponder()
        default:
            return
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        indicator.startAnimating()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.searchBarTextDidPause(_:)), userInfo: searchBar.text, repeats: false)
        
        return true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        clearTable()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}
