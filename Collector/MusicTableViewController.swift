//
//  MusicTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 15/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MusicTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,MediaPageControllerDelegate {
    
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
        static let musicDetailTableSegueId = "showMusicDetailTable"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
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

    // MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.musicCellId) as! MediaBoxTableViewCell
        cell.media = controller!.filteredMusic![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller!.filteredMusic != nil ? controller!.filteredMusic!.count : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if controller!.filter != nil {
            let headerView = tableView.dequeueReusableCellWithIdentifier(Storyboard.headerCell) as! HeaderTableViewCell
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
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return controller!.filter != nil ? 55.0 : 0.0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.musicDetailTableSegueId {
            let dest = segue.destinationViewController as! MusicDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            dest.music = controller!.filteredMusic![(indexPath?.row)!]
            dest.context = controller!.context
        }
    }

    func reloadData() {
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    func indexPaths() -> [NSIndexPath]? {
        return [NSIndexPath()]
        //return collectionView.indexPathsForSelectedItems()
    }
}
