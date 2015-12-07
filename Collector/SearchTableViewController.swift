//
//  SearchTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 19/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

@IBDesignable
class SearchTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    // MARK: - Variables and constances
    private struct Storyboard {
            static let mediaCellId = "media cell"
    }
    
    var media = [Media]()
    var storage = Storage()
    
    @IBOutlet weak var movieTableCell: UITableViewCell!
    @IBOutlet weak var musicTableCell: UITableViewCell!

    @IBOutlet weak var searchMediaBar: UISearchBar! {
        didSet {
            self.searchMediaBar.delegate = self
        }
    }
    
    @IBOutlet weak var movieResultsCollectionView: UICollectionView! {
        didSet {
            self.movieResultsCollectionView.delegate = self
            self.movieResultsCollectionView.dataSource = self
        }
    }

    @IBOutlet weak var musicResultsCollectionView: UICollectionView! {
        didSet {
            self.musicResultsCollectionView.delegate = self
            self.musicResultsCollectionView.dataSource = self
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
               print("BeEd")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
                print("EndEd")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("cancel")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("search")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.mediaCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = media[indexPath.row].title
        cell.releaseYearLabel.text = "\(media[indexPath.row].releaseYear)"
        cell.coverArt.image = media[indexPath.row].coverArt

        return cell
    }
}
