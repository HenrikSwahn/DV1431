//
//  SearchEntryTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 19/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import MobileCoreServices

class SearchEntryTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate, ViewContext, SearchAPIDelegate {
    
    var context = ViewContextEnum.Unkown
    var search: SearchAPI!
    
    private struct Storyboard {
        static let manualEntrySegueId = "ManualEntrySegue"
        static let movieReuseIdentifier = "MovieResultCell"
        static let musicReuseIdentifier = "MusicResultCell"
    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.indicatorShouldStopAnimating()
        
        self.search = SearchAPI(context: ViewContextEnum.Music,
            reuseIdentifierForMovie: Storyboard.movieReuseIdentifier,
            reuseIdentifierForMusic: Storyboard.musicReuseIdentifier)
        
        self.search.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
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
        return self.search.cellForIndexPath(tableView, indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        print(error)
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
}
