//
//  MusicHomeViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-07.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MusicHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, ViewContext, FilterDelegate {
    
    private struct Storyboard {
        static let musicCellId = "media cell"
        static let addMusicSegue = "addMusicSegue"
        static let musicDetailColSegueId = "showMusicDetailCol"
        static let musicDetailTableSegueId = "showMusicDetailTable"
        static let filterMusicSegue = "filterMusicSegue"
    }
    
    var context = ViewContextEnum.Music
    
    var filter: Filter? {
        didSet {
            if self.filter == nil {
                filteredMusic = music
            }
            else {
                filteredMusic = filter!.filterMusic(music!)
                self.musicTableView.reloadData()
                self.musicCollectionView.reloadData()
            }
        }
    }
    
    private var music: [Music]? {
        didSet {
            if self.filter == nil {
                filteredMusic = music
            }
            else {
                filteredMusic = filter!.filterMusic(music!);
                self.musicTableView.reloadData()
                self.musicCollectionView.reloadData()
            }
        }
    }
    var filteredMusic: [Music]?
    let storage = Storage();
    
    
    @IBOutlet weak var musicTableView: UITableView! {
        didSet {
            self.musicTableView.delegate = self
            self.musicTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var musicCollectionView: UICollectionView! {
        didSet {
            self.musicCollectionView.delegate = self
            self.musicCollectionView.dataSource = self
        }
    }
    
    @IBAction func changeViewLayout(sender: AnyObject) {
        
        self.musicCollectionView.hidden = !self.musicCollectionView.hidden
        self.musicTableView.hidden = !self.musicTableView.hidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.musicCollectionView.hidden = true
        self.musicTableView.hidden = false
        music = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Music), doConvert: true) as? [Music]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        music = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Music), doConvert: true) as? [Music]
        self.musicTableView.reloadData()
        self.musicCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.musicCellId) as! MediaTableViewCell
        cell.titleLabel.text = filteredMusic![indexPath.row].title
        cell.releaseYearLabel.text = "\(filteredMusic![indexPath.row].releaseYear)"
        cell.runtimeLabel.text = "\(filteredMusic![indexPath.row].runtime.toString())"
        cell.coverArt.image = filteredMusic![indexPath.row].coverArt
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filteredMusic != nil) {
            return filteredMusic!.count
        }
        return 0
    }
    
    // MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (filteredMusic != nil) {
            return filteredMusic!.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.musicCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = filteredMusic![indexPath.row].title
        cell.releaseYearLabel.text = "\(filteredMusic![indexPath.row].releaseYear)"
        cell.coverArt.image = filteredMusic![indexPath.row].coverArt
        return cell
    }
    
    // MARK: - Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == Storyboard.addMusicSegue {
            let navCtr = segue.destinationViewController as! UINavigationController
            let dest = navCtr.topViewController as! SearchEntryTableViewController
            dest.context = context
        }
        else if segue.identifier == Storyboard.musicDetailTableSegueId {
            let dest = segue.destinationViewController as! MusicDetailViewController
            let indexPath = self.musicTableView.indexPathForSelectedRow
            dest.music = filteredMusic![(indexPath?.row)!]
            dest.context = context
        }
        else if segue.identifier == Storyboard.musicDetailColSegueId {
            let indexPaths = self.musicCollectionView.indexPathsForSelectedItems()
            if (indexPaths != nil) {
                let indexPath = indexPaths![0]
                let dest = segue.destinationViewController as! MusicDetailViewController
                dest.music = filteredMusic![indexPath.row]
                dest.context = context
            }
        }
        else if segue.identifier == Storyboard.filterMusicSegue {
            let dest = segue.destinationViewController as! UINavigationController
            let destTop = dest.topViewController as! FilterTableViewController
            destTop.delegate = self
            destTop.context = context
        }
    }
    
    // MARK: - Filter Delegate
    func didSelectFilter(filter: Filter?) {
        self.filter = filter
    }
}
