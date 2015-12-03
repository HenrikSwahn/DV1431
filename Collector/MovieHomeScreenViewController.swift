//
//  HomeScreenViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-18.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MovieHomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ViewContext {
    
    // MARK: - Variables and constatns
    private struct Storyboard {
        static let mediaCellId = "media cell"
        static let addMovieSegueId = "AddMovieSegue"
        static let detailMovieSegueId = "DetailMovieSegue"
    }
    
    private let storage = Storage()
    private var media: [Media]?
    internal var context = ViewContextEnum.Movie
    
    @IBOutlet weak var mediaTable: UITableView! {
        didSet {
            self.mediaTable.delegate = self
            self.mediaTable.dataSource = self
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaCellId) as! MediaTableViewCell
        cell.titleLabel.text = media![indexPath.row].title
        cell.releaseYearLabel.text = "\(media![indexPath.row].releaseYear)"
        cell.runtimeLabel.text = "\(media![indexPath.row].runtime.toString())"
        cell.coverArt.image = media![indexPath.row].coverArt
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media!.count
    }
    
    // MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.mediaCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = media![indexPath.row].title
        cell.releaseYearLabel.text = "\(media![indexPath.row].releaseYear)"
        cell.coverArt.image = media![indexPath.row].coverArt
        return cell
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Storyboard.addMovieSegueId {
            let navCtr = segue.destinationViewController as! UINavigationController
            let dest = navCtr.topViewController as! SearchEntryTableViewController
            dest.context = context
        }
        else if segue.identifier == Storyboard.detailMovieSegueId {
            let dest = segue.destinationViewController as! MediaDetailViewController
            let indexPath = self.mediaTable.indexPathForSelectedRow
            dest.media = media![(indexPath?.row)!]
            dest.context = context
        }
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaCollection.hidden = true
        //storage.emptyDatabase()
        media = storage.getMovies()!
    }
    
    override func viewDidAppear(animated: Bool) {
        media = storage.getMovies()
        mediaTable.reloadData()
    }
}
