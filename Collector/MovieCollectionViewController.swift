//
//  MovieCollectionViewController.swift
//  Collector
//
//  Created by Dino Opijac on 14/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MediaPageControllerDelegate {

    var parentController: MediaPageViewController?
    var controller: MoviePageController? {
        get {
            return parentController as? MoviePageController
        }
    }
    
    private struct Storyboard {
        static let mediaCellId = "media cell"
        static let colFilterHeader = "colFilterHeader"
        static let detailMovieSegueCollectionId = "DetailMovieSegueCollection"
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller!.filteredMovies != nil ? controller!.filteredMovies!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.mediaCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = controller!.filteredMovies![indexPath.row].title
        cell.releaseYearLabel.text = "\(controller!.filteredMovies![indexPath.row].releaseYear)"
        cell.coverArt.image = controller!.filteredMovies![indexPath.row].coverArt
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if controller!.filter != nil {
            if kind == UICollectionElementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: Storyboard.colFilterHeader, forIndexPath: indexPath) as! HeaderCollectionReusableView
                headerView.delegate = controller!
                if let genre = controller!.filter!.genre {
                    headerView.genreLabel.text = genre
                }
                else {
                    headerView.genreLabel.text = "N/A"
                }
                
                if let year = controller!.filter?.year {
                    headerView.yearLabel.text = "\(year)"
                }
                else {
                    headerView.yearLabel.text = "N/A"
                }
                
                if let rating = controller!.filter!.rating {
                    headerView.ratingLabel.text = "\(rating)"
                }
                else {
                    headerView.ratingLabel.text = "N/A"
                }
                
                return headerView
            }
        }
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: Storyboard.colFilterHeader, forIndexPath: indexPath) as! HeaderCollectionReusableView
        return view
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(
                width: collectionView.frame.width,
                height: controller!.filter != nil ? 55 : 0
            )
    }


    func reloadData() {
        if collectionView != nil {
            collectionView.reloadData()
        }
    }
    
    func indexPaths() -> [NSIndexPath]? {
        return collectionView.indexPathsForSelectedItems()
    }
    
    // Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.detailMovieSegueCollectionId {
            let indexPaths = collectionView.indexPathsForSelectedItems()
            if (indexPaths != nil) {
                let indexPath = indexPaths![0]
                let dest = segue.destinationViewController as! MovieDetailViewController
                dest.movie = controller!.filteredMovies![indexPath.row]
                dest.context = controller!.context
            }
        }
    }
}
