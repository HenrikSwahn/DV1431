//
//  HomeScreenViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-18.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MovieHomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ViewContext, FilterDelegate {
    
    // MARK: - Variables and constatns
    private struct Storyboard {
        static let mediaCellId = "media cell"
        static let addMovieSegueId = "AddMovieSegue"
        static let detailMovieSegueTableId = "DetailMovieSegueTable"
        static let detailMovieSegueCollectionId = "DetailMovieSegueCollection"
        static let filterSegue = "filterSegue"
    }
    
    private let storage = Storage()
    private var movies: [Movie]? {
        didSet {
            if self.filter == nil {
                filteredMovies = movies;
            }
            else {
                filteredMovies = filter!.filterMovies(movies!);
                self.mediaTable.reloadData()
            }
        }
    }
    private var filteredMovies:[Movie]?
    internal var context = ViewContextEnum.Movie
    
    var filter: Filter? {
        didSet {
            if self.filter == nil {
                filteredMovies = movies;
            }
            else {
                filteredMovies = filter!.filterMovies(movies!);
                self.mediaTable.reloadData()
            }
        }
    }
    
    @IBOutlet weak var mediaTable: UITableView! {
        didSet {
            self.mediaTable.delegate = self
            self.mediaTable.dataSource = self
            mediaTable.estimatedRowHeight = mediaTable.rowHeight
            mediaTable.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var mediaCollection: UICollectionView! {
        didSet {
            self.mediaCollection.delegate = self
            self.mediaCollection.dataSource = self
            self.mediaCollection.backgroundColor = UIColor.whiteColor()
        }
    }
    
    @IBAction func changeView(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.mediaTable.hidden = false
            self.mediaCollection.hidden = true
        case 1:
            self.mediaTable.hidden = true
            self.mediaCollection.hidden = false
        default:
            break
        }
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaCellId) as! MediaRectangleTableViewCell
        cell.media = filteredMovies![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (filteredMovies != nil) {
            return filteredMovies!.count
        }
        return 0
    }
    
    // MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (filteredMovies != nil) {
            return filteredMovies!.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.mediaCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = filteredMovies![indexPath.row].title
        cell.releaseYearLabel.text = "\(filteredMovies![indexPath.row].releaseYear)"
        cell.coverArt.image = filteredMovies![indexPath.row].coverArt
        return cell
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Storyboard.addMovieSegueId {
            let navCtr = segue.destinationViewController as! UINavigationController
            let dest = navCtr.topViewController as! SearchEntryTableViewController
            dest.context = context
        }
        else if segue.identifier == Storyboard.detailMovieSegueTableId {
            let dest = segue.destinationViewController as! MovieDetailViewController
            let indexPath = self.mediaTable.indexPathForSelectedRow
            dest.movie = filteredMovies![(indexPath?.row)!]
            dest.context = context
        }
        else if segue.identifier == Storyboard.detailMovieSegueCollectionId {
            let indexPaths = self.mediaCollection.indexPathsForSelectedItems()
            if (indexPaths != nil) {
                let indexPath = indexPaths![0]
                let dest = segue.destinationViewController as! MovieDetailViewController
                dest.movie = filteredMovies![indexPath.row]
                dest.context = context
            }
        }
        else if segue.identifier == Storyboard.filterSegue {
            let dest = segue.destinationViewController as! UINavigationController
            let destTop = dest.topViewController as! FilterTableViewController
            destTop.delegate = self
            destTop.context = context
        }
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaCollection.hidden = true
        movies = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Movie), doConvert: true) as? [Movie]
    }
    
    override func viewDidAppear(animated: Bool) {
        movies = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Movie), doConvert: true) as? [Movie]
        mediaTable.reloadData()
        
    }
    
    // MARK: - Filter Delegate
    func didSelectFilter(filter: Filter?) {
        self.filter = filter
    }
}
