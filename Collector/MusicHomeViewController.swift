//
//  MusicHomeViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-07.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MusicHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, ViewContext {
    
    private struct Storyboard {
        static let musicCellId = "media cell"
        static let addMusicSegue = "addMusicSegue"
        static let musicDetailColSegueId = "showMusicDetailCol"
        static let musicDetailTableSegueId = "showMusicDetailTable"
    }
    
    var context = ViewContextEnum.Music
    var music: [Music]?
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
        
        /*var mu1 = Music(title: "Clayman", released: 1996);
        mu1.insertTrack(Track(name: "Track1", runtime: Runtime(hours: 0, minutes: 3, seconds: 26), trackNr: 1))
        mu1.insertTrack(Track(name: "Track2", runtime: Runtime(hours: 0, minutes: 3, seconds: 17), trackNr: 2))
        mu1.insertTrack(Track(name: "Track3", runtime: Runtime(hours: 0, minutes: 3, seconds: 28), trackNr: 3))
        mu1.insertTrack(Track(name: "Track4", runtime: Runtime(hours: 0, minutes: 3, seconds: 21), trackNr: 4))
        mu1.desc = "Awesome inflames album"
        mu1.setFormat("CD");
        mu1.setOwningType("Physical");
        mu1.genre = "Metal"
        mu1.albumArtist = "inFlames"
        mu1.ownerLocation = "Section A"
        storage.storeMusic(mu1);*/
        music = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Music)) as? [Music]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.musicCellId) as! MediaTableViewCell
        cell.titleLabel.text = music![indexPath.row].title
        cell.releaseYearLabel.text = "\(music![indexPath.row].releaseYear)"
        cell.runtimeLabel.text = "\(music![indexPath.row].runtime.toString())"
        cell.coverArt.image = music![indexPath.row].coverArt
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (music != nil) {
            return music!.count
        }
        return 0
    }
    
    // MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (music != nil) {
            return music!.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.musicCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = music![indexPath.row].title
        cell.releaseYearLabel.text = "\(music![indexPath.row].releaseYear)"
        cell.coverArt.image = music![indexPath.row].coverArt
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
            dest.music = music![(indexPath?.row)!]
            dest.context = context
        }
        else if segue.identifier == Storyboard.musicDetailColSegueId {
            let indexPaths = self.musicCollectionView.indexPathsForSelectedItems()
            if (indexPaths != nil) {
                let indexPath = indexPaths![0]
                let dest = segue.destinationViewController as! MusicDetailViewController
                dest.music = music![indexPath.row]
                dest.context = context
            }
        }
    }
}
