//
//  MediaDetailViewController.swift
//  Collector
//
//  Created by Dino Opijac on 24/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import AVKit

class MovieDetailViewController: UIBarStyleController, UITableViewDelegate, UITableViewDataSource, ViewContext, RatingViewDelegate, PlayerPresenter {

    // MARK: - Context
    var context = ViewContextEnum.Movie
    var movie: Movie?
    
    // MARK: - Private Members
    private var data: [[AnyObject]]?
    private var colors: UIImageColors?

    private struct Storyboard {
        static let editMovieSegue = "EditMovie"
        static let generalCell = "generalCell"
        static let descriptionCell = "descriptionCell"
        static let trailerCellID = "trailerCellID"
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ratingView: UIRatingView!
    
    
    @IBOutlet weak var titleLabel: UIMarqueeLabel!
    @IBOutlet weak var detailLabel: UIMarqueeLabel!
    
    @IBOutlet weak var tableView: UIStretchableTableView!
  
    
    // MARK: - View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let rat = self.movie?.rating {
            self.ratingView.rating = Float(rat)
        }
        
        let storage = Storage()
        var results = (storage.searchDatabase(DBSearch(table: .MovieId, searchString: movie!.id, batchSize: nil, set: .Movie), doConvert: true) as? [Movie])
        
        if results != nil {
            if results!.count > 0 {
                movie = results![0]
                updateData(movie!)
            }
        }

        tabBarSeparatorColor = colors?.secondaryColor
        tabBarBackgroundColor = colors?.backgroundColor
        tabBarTintColor = colors?.primaryColor
        
        navigationBarBackgroundColor = colors?.backgroundColor
        navigationBarTintColor = colors?.primaryColor
        navigationBarSeparator?.backgroundColor = colors?.secondaryColor
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = (scrollView.contentOffset.y + tableView.headerHeight! + 64) / 64
        navigationBarView?.alpha = offset > 0.95 ? 0.95 : offset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Make table cells resizable
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        ratingView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Rating View
    func ratingView(ratingView: UIRatingView, didUpdate rating: Float) {
        let storage = Storage()
        movie!.rating = Int(rating)
        storage.updateMovieObject(movie!)
    }
    
    func ratingView(ratingView: UIRatingView, isUpdating rating: Float) {
        
    }
    
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = data {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = data {
            return rows[section].count - 1
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let title = data {
            return title[section][0] as? String
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1, 2, 3:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.generalCell, forIndexPath: indexPath) as? GeneralDetailTableViewCell {
                cell.model = data?[indexPath.section][indexPath.row + 1]
                cell.colors = colors
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.trailerCellID, forIndexPath: indexPath) as? TrailerTableViewCell {
                cell.delegate = self
                cell.model = data?[indexPath.section][indexPath.row + 1]
                cell.colors = colors
                return cell
            }
        case 0:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.descriptionCell, forIndexPath: indexPath) as? ValueTableViewCell {
                cell.model = data?[indexPath.section][indexPath.row + 1]
                cell.colors = colors
                return cell
            }
        default: break
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = colors?.primaryColor
        }
    }
    
    
    // MARK: - Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.editMovieSegue {
            if let dest = segue.destinationViewController as? MovieManualEntryViewController {
                dest.context = .EditMovie
                dest.movie = movie
            }
        }
    }
    
    
    // MARK: - Updating
    func updateUI() {
        coverImageView.image = movie?.coverArt
        titleLabel.text = movie?.title
        titleLabel.type = .LeftRight
        titleLabel.scrollRate = 100.0
        titleLabel.fadeLength = 20.0
        
        detailLabel.text = movie?.genre
        detailLabel.type = .LeftRight
        detailLabel.scrollRate = 100.0
        detailLabel.fadeLength = 20.0
        
        colors = coverImageView.image?.getColors(coverImageView.frame.size)
        
        if let color = colors {
            let saturation = color.backgroundColor.colorWithMinimumSaturation(0.1)
            tableView.backgroundColor = saturation
            tableView.separatorColor = color.primaryColor
        }
        
        // Sets the background image to the cover image
        self.backgroundImageView.image = self.coverImageView.image
        
        // Drop a shadow around the cover image
        coverImageView.dropShadow()
        
        if let rat = self.movie?.rating {
            self.ratingView.rating = Float(rat)
        }
    }
    
    func updateData(movie: Movie) {
        data = MovieAdapter.tableView(movie)
        tableView.reloadData()
        updateUI()
    }
    
    
    // MARK: - Actions (rating, delete)
    @IBAction func deleteAction(sender: UIButton) {
        if let item = movie {
            
            let controller = UIAlertController(
                title:          "Delete",
                message:        "Would you like to delete this item from the library?",
                preferredStyle: .ActionSheet
            )
            
            controller.addAction(UIAlertAction(
                title: "Delete",
                style: .Destructive,
                handler: { [unowned self] (_) -> Void in
                    let storage = Storage()
                    storage.removeFromDB(DBSearch(
                        table: .Id,
                        searchString: item.id,
                        batchSize: nil,
                        set: .Movie))
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }))
            
            controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - PlayerPresenter
    func presentPlayer(playerVC: AVPlayerViewController) {
        self.presentViewController(playerVC, animated: true) {
            playerVC.player!.play()
        }
    }
}