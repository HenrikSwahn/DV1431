//
//  HomeScreenViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-18.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Variables and constatns
    private struct Storyboard {
        static let mediaCellId = "media cell"
    }
    
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
    private var media = [Media]()
    
    
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
        cell.titleLabel.text = media[indexPath.row].name
        cell.releaseYearLabel.text = "\(media[indexPath.row].release)"
        cell.runtimeLabel.text = media[indexPath.row].length
        cell.coverArt.image = media[indexPath.row].image
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media.count
    }
    
    // MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.mediaCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = media[indexPath.row].name
        cell.releaseYearLabel.text = "\(media[indexPath.row].release)"
        cell.coverArt.image = media[indexPath.row].image
        return cell
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaCollection.hidden = true
        //self.navigationController?.navigationBar.backgroundColor = UIColor.greenColor()
        // Do any additional setup after loading the view.
        let mov1 = Media(named: "I am Legend", released: 2007, length: "1 hour 43 minutes", image: UIImage(named: "placeholder-movie"))
        let mov2 = Media(named: "Indiana Jones and The temple of doom", released: 1989, length: "2 hour 6 minutes", image: UIImage(named: "placeholder-movie"))
        let mov3 = Media(named: "Interstellar", released: 2014, length: "2 hour 49 minutes", image: UIImage(named: "placeholder-movie"))
        let mov4 = Media(named: "The Lord of the Rings: The Return of the King", released: 2003, length: "3 hour 21 minutes", image: UIImage(named: "placeholder-movie"))
        
        media += [mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4]
    }
}
