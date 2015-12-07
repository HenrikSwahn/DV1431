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
        static let mediaDetailSegueIdForMovie = "mediaDetailSegue-Movie"
        static let mediaDetailSegueIdForMusic = "mediaDetailSegue-Music"
    }
    
    var movies: [Movie]?
    var filteredMovies: [Movie]?
    var music: [Music]?
    var filteredMusic: [Music]?
    var filtered = false
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
    
    func filter(text: String) {
        
        if (movies != nil) {
            self.filteredMovies = self.movies!.filter({(movie: Movie) -> Bool in
                let titleMatch = movie.title.rangeOfString(text)
                return (titleMatch != nil)
            })
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count == 0 {
            filtered = false
            self.movieResultsCollectionView.reloadData()
        }
        else {
            filtered = true
            filter(searchText)
            self.movieResultsCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        movies = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Movie)) as? [Movie]
        //music = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set:.Music)) as! [Music]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.movieResultsCollectionView {
            if (movies != nil) {
                if filtered {
                    return filteredMovies!.count
                }
            }
        }
        else {
            if (music != nil) {
                if filtered {
                    return filteredMusic!.count
                }
            }
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.mediaCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
    
        cell.titleLabel.text = filteredMovies![indexPath.row].title
        cell.coverArt.image = filteredMovies![indexPath.row].coverArt
        cell.releaseYearLabel.text = "\((filteredMovies![indexPath.row].releaseYear))"
    
        return cell
    }
    
    // MARK: - Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Storyboard.mediaDetailSegueIdForMovie {
            
            let indexPaths = self.movieResultsCollectionView.indexPathsForSelectedItems()
            
            if (indexPaths != nil) {
                let indexPath = indexPaths![0]
                let dest = segue.destinationViewController as! MediaDetailViewController
                dest.media = filteredMovies![indexPath.row]
                dest.context = .Movie
            }
        }
        else if segue.identifier == Storyboard.mediaDetailSegueIdForMusic {
            // Todo
        }
    }
}
