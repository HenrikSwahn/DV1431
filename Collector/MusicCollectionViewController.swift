//
//  MusicCollectionViewController.swift
//  Collector
//
//  Created by Dino Opijac on 15/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MusicCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerPreviewingDelegate, MediaPageControllerDelegate {

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

        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
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

    // MARK: - UIViewPreviewingDelegate
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItemAtPoint(location) else { return nil }
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) else { return nil }
        
        guard let detailVC = storyboard?.instantiateViewControllerWithIdentifier("MusicDetailViewController") as? MusicDetailViewController else { return nil }
        
        detailVC.music = controller!.filteredMusic![indexPath.row]
        detailVC.context = controller!.context
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = cell.frame
        return detailVC
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
    func reloadData() {
        if collectionView != nil {
            collectionView.reloadData()
        }
    }
}
