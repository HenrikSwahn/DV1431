//
//  MusicCollectionViewController.swift
//  Collector
//
//  Created by Dino Opijac on 15/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MusicCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MediaPageControllerDelegate {

    var parentController: MediaPageViewController?
    var controller: MusicPageController? {
        get {
            return parentController as? MusicPageController
        }
    }
    
    private struct Storyboard {
        static let musicCellId = "media cell"
        static let headerCell = "HeaderCell"
        static let colFilterHeader = "ColFilterHeader"
        static let musicDetailColSegueId = "showMusicDetailCol"
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller!.filteredMusic != nil ? controller!.filteredMusic!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.musicCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = controller!.filteredMusic![indexPath.row].title
        cell.releaseYearLabel.text = "\(controller!.filteredMusic![indexPath.row].releaseYear)"
        cell.coverArt.image = controller!.filteredMusic![indexPath.row].coverArt
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
                height: controller!.filter != nil ? 55.0 : 0
            )
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.musicDetailColSegueId {
            let indexPaths = collectionView.indexPathsForSelectedItems()
            
            if (indexPaths != nil) {
                let indexPath = indexPaths![0]
                let dest = segue.destinationViewController as! MusicDetailViewController
                dest.music = controller!.filteredMusic![indexPath.row]
                dest.context = controller!.context
            }
        }
    }

    func reloadData() {
        if collectionView != nil {
            collectionView.reloadData()
        }
    }
    
    func indexPaths() -> [NSIndexPath]? {
        return [NSIndexPath()]
        //return collectionView.indexPathsForSelectedItems()
    }
}
