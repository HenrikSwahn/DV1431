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
        static let mediaCellId = "AddMusicSegue"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*var mu1 = Music(title: "Clayman", released: 1996);
        mu1.insertTrack(Track(name: "Track1", runtime: Runtime(hours: 0, minutes: 3, seconds: 26)))
        mu1.insertTrack(Track(name: "Track2", runtime: Runtime(hours: 0, minutes: 3, seconds: 17)))
        mu1.insertTrack(Track(name: "Track3", runtime: Runtime(hours: 0, minutes: 3, seconds: 28)))
        mu1.insertTrack(Track(name: "Track4", runtime: Runtime(hours: 0, minutes: 3, seconds: 21)))
        mu1.desc = "Awesome inflames album"
        mu1.setFormat("CD");
        mu1.setOwningType("Physical");
        mu1.genre = "Metal"
        mu1.albumArtist = "inFlames"
        mu1.ownerLocation = "Section A"
        storage.storeMusic(mu1);*/
        //music = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Music)) as? [Music]
        
        /*for track in music![0].trackList {
            print(track.name)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaCellId) as! MediaTableViewCell
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.mediaCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = music![indexPath.row].title
        cell.releaseYearLabel.text = "\(music![indexPath.row].releaseYear)"
        cell.coverArt.image = music![indexPath.row].coverArt
        return cell
    }
}
