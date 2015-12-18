//
//  SearchEntryTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 19/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import MobileCoreServices

class SearchEntryTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate, ViewContext, SearchAPIDelegate, UITableViewCachable {
    
    var context = ViewContextEnum.Unkown
    var search: SearchAPI!
    
    private struct Storyboard {
        static let manualEntrySegueId   = "ManualEntrySegue"
        static let musicSegueId = "MusicSegue"
        static let movieSegueId = "movieSegue"
        static let movieReuseIdentifier = "MovieResultCell"
        static let musicReuseIdentifier = "MusicResultCell"
    }
    
    private struct Placeholder {
        static let Music = "Search for albums ..."
        static let Movie = "Search for movies ..."
        static let Unknown = "Unknown context"
    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            switch self.context {
                case .Music: self.searchBar.placeholder = Placeholder.Music
                case .Movie: self.searchBar.placeholder = Placeholder.Movie
                default: self.searchBar.placeholder     = Placeholder.Unknown
            }
        }
    }
    @IBAction func cancelButtonItem(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Image
    @IBAction func photoButtonItem(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.delegate = self
            picker.allowsEditing = false
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Capturing of images, etc.
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
    
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == Storyboard.manualEntrySegueId {
            let dest = segue.destinationViewController as! ManualEntryTableViewController
            dest.context = context
        }
        else if segue.identifier == Storyboard.musicSegueId {
            let dest = segue.destinationViewController as! MusicManualEntryViewController
            dest.context = context
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SearchMusicEntryTableViewCell
                dest.image = cell.albumImage.image
                dest.itunesAlbumItem = self.search.getForSelectedAlbumIndexPath(indexPath)
                
            }
        }
        else if segue.identifier == Storyboard.movieSegueId {
            let dest = segue.destinationViewController as! MovieManualEntryViewController
            dest.context = context
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SearchMovieEntryTableViewCell
                dest.image = cell.movieImage.image
                dest.tmdbSearchItem = self.search.getForSelectedMovieIndexPath(indexPath)
            }
        }
    }
    
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.indicatorShouldStopAnimating()
        
        if (context == .Unkown) {
            self.searchBar.userInteractionEnabled = false
        }
        
        self.search = SearchAPI(context: context,
            reuseIdentifierForMovie: Storyboard.movieReuseIdentifier,
            reuseIdentifierForMusic: Storyboard.musicReuseIdentifier)
        
        self.search?.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.cachableStore = [String:UIImage]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.search.count()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let dequeued = self.search.cellForIndexPath(tableView, indexPath: indexPath) as? UICachableTableViewCell {
            dequeued.delegate = self
            return dequeued
        }
        
        return self.search.cellForIndexPath(tableView, indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [
            UITableViewRowAction(style: .Normal, title: "✚\nWish List", handler: wishAction())
        ]
    }
    
    // MARK: - SearchBar delegates
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.indicatorShouldStartAnimating()
        self.search.perform(searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            self.search.empty()
            self.tableView.reloadData()

            self.indicatorShouldStopAnimating()
        }
    }
    
    // MARK: - SearchAPI delegate
    func searchAPI(count: Int) {
        self.tableView.reloadData()
        self.indicatorShouldStopAnimating()
    }
    
    func searchAPI(didFail error: NSError) {
        self.indicatorShouldStopAnimating()
    }
    
    func indicatorShouldStopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.hidden = true
    }
    
    func indicatorShouldStartAnimating() {
        self.activityIndicatorView.startAnimating()
        self.activityIndicatorView.hidden = false
    }
    
    
    // MARK: - Cachable
    var cachableStore: [String:UIImage]?
    
    func cachableTableView(didStore identifier: String) -> UIImage? {
        return cachableStore?[identifier]
    }
    
    func cachableTableView(willStore identifier: String, image: UIImage) {
        cachableStore?[identifier] = image
    }
    
    // MARK: - Wishlist
    func wishAction() -> (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void {
        return { [unowned self] (action, indexPath) in
            var wishListItem: WishListItem?

            // Insert this item to the wishlist
            switch self.context {
                case .Movie:
                    let movie: SearchMovieEntryTableViewCell? = self.search.cellForRowAtIndexPath(self.tableView, indexPath: indexPath)
                    guard movie != nil else { break }
                    wishListItem = movie!.toWishListItem()
                
                case .Music:
                    let album: SearchMusicEntryTableViewCell? = self.search.cellForRowAtIndexPath(self.tableView, indexPath: indexPath)
                    guard album != nil else { break }
                    wishListItem = album!.toWishListItem()
                
                // Future proof
                //case .Game:
                //case .Book:
                default: break;
            }
            
            if let item = wishListItem {
                let storage = Storage()
                storage.storeWishListItem(item)
            }

            self.tableView.setEditing(false, animated: true)
        }
    }
}

extension SearchMovieEntryTableViewCell {
    internal func toWishListItem() -> WishListItem {
        return WishListItem(
            id:         0,
            aid:        self.identifier,
            type:       .Movie,
            imageData:  self.movieImage.image,
            title:      self.titleLabel.text ?? "",
            detail:     self.synopsisLabel.text ?? "")
    }
}


extension SearchMusicEntryTableViewCell {
    internal func toWishListItem() -> WishListItem {
        return WishListItem(
            id:         0,
            aid:        self.identifier,
            type:       .Music,
            imageData:  self.albumImage.image,
            title:      self.titleLabel.text ?? "",
            detail:     self.artistLabel.text ?? "")
    }
}