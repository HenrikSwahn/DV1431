//
//  MovieTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 14/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MovieTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MediaPageControllerDelegate {
    
    var parentController: MediaPageViewController?
    var controller: MoviePageController? {
        get {
            return parentController as? MoviePageController
        }
    }
    
    private struct Storyboard {
        static let mediaCellId = "media cell"
        static let headerCell = "HeaderCell"
        static let detailMovieSegueTableId = "DetailMovieSegueTable"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaCellId)!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let c = cell as? MediaRectangleTableViewCell {
            c.media = controller?.filteredMovies![indexPath.row]
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller!.filteredMovies != nil ? controller!.filteredMovies!.count : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if controller!.filter != nil {
            let headerView = tableView.dequeueReusableCellWithIdentifier(Storyboard.headerCell) as! HeaderTableViewCell
            headerView.delegate = controller
            
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
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return controller!.filter != nil ? 55.0 : 0.0
    }
    
    func reloadData() {
        if tableView != nil {
            tableView.reloadData()
        }
    }

    
    // Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.detailMovieSegueTableId {
            let dest = segue.destinationViewController as! MovieDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            dest.movie = controller!.filteredMovies![(indexPath?.row)!]
            dest.context = controller!.context
        }
    }
}
