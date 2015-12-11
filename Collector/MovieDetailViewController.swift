//
//  MediaDetailViewController.swift
//  Collector
//
//  Created by Dino Opijac on 24/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewContext, RatingViewDelegate {
    
    var movie: Movie?
    var context = ViewContextEnum.Movie
    
    // MARK: - Private Members
    private var colors: UIImageColors?
    private var genericData = [(String, String)]()
    private struct Storyboard {
        static let mediaDetailTableCellIdentifier = "media detail cell id"
        static let editMovieSegue = "editMovieSegue"
    }
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UIMarqueeLabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingView: UIRatingView!
    
    @IBOutlet weak var ownerLocationLabel: UILabel!
    @IBOutlet weak var ownerTypeLabel: UILabel!
    @IBOutlet weak var tableView: UIStretchableTableView! {
        didSet {
            // The tableView will not conform to Storyboard Clear color property
            // it has to be set in code.
            tableView.backgroundColor = UIColor.clearColor()
        }
    }
    
    private func setData() {
        
        if let year = movie?.releaseYear {
            self.yearLabel.text = String(year)
        }
        
        if let title = movie?.title {
            self.titleLabel.text = title
        }
        
        if let runtime = movie?.runtime {
            self.runtimeLabel.text = runtime.toString()
        }
        
        if let genre = movie?.genre {
            self.genreLabel.text = genre
        }
        
        if let ownerLocation = movie?.ownerLocation {
            self.ownerLocationLabel.text = ownerLocation
        }
        
        if let ownerType = movie?.owningType {
            self.ownerTypeLabel.text = ownerType.rawValue
        }
        
        if let coverArt = movie?.coverArt {
            self.coverImageView.image = coverArt
        }
        
        if let format = movie?.format {
            self.genericData.append(("Format", format.rawValue))
        }
        
        movieSpecificData();
    }
    
    private func movieSpecificData() {
        
        if let synopsis = movie!.desc {
            self.genericData.insert(("Synopsis", synopsis), atIndex: 0)
        }
        
        if let ageRestriction = movie!.ageRestriction {
            self.genericData.append(("Age restriction",String(ageRestriction)))
        }
        
        if let mainActor = movie!.mainActors {
            self.genericData.append(("Main actor",String(mainActor)))
        }
        
        if let director = movie!.director {
            self.genericData.append(("Director",String(director)))
        }
    }
    
    private func updateColor() {
        if let c = colors {
            let color = c.primaryColor.isDarkColor ? c.primaryColor : c.backgroundColor

            self.titleLabel.textColor = color
            self.yearLabel.textColor = color
            self.runtimeLabel.textColor = color
            self.genreLabel.textColor = color
            self.ownerLocationLabel.textColor = c.backgroundColor
            self.ownerTypeLabel.textColor = c.backgroundColor
            
            // Background color
            self.view.backgroundColor = c.secondaryColor
        }
    }

    
    // MARK: - View Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let rat = self.movie?.rating {
            self.ratingView.rating = Float(rat)
        }
        
        let storage = Storage()
        var results = (storage.searchDatabase(DBSearch(table: .MovieId, searchString: movie!.id, batchSize: nil, set: .Movie), doConvert: true) as? [Movie])
        
        if results != nil {
            if results!.count > 0 {
                movie = results![0]
                setData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Make table cells resizable
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set mock data
        //self.setMockData()
        setData()
        
        // Sets the background image to the cover image
        self.headerImageView.image = self.coverImageView.image
        
        // Drop a shadow around the cover image
        coverImageView.dropShadow()
        
        // Get the dominant color from the cover image
        let size = self.coverImageView.frame.size
        self.colors = self.coverImageView.image?.getColors(size)
        self.updateColor()
        
        // Do any additional setup after loading the view.
        self.titleLabel.type = .LeftRight
        self.titleLabel.scrollRate = 100.0
        self.titleLabel.fadeLength = 20.0
        self.ratingView.delegate = self
        
        if let rat = self.movie?.rating {
            self.ratingView.rating = Float(rat)
        }
        
        // Hide empty table cells
        self.hideEmptyTableViewCells()
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
    private func hideEmptyTableViewCells() {
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaDetailTableCellIdentifier) as! MediaDetailTableViewCell

        cell.keyLabel?.text = genericData[indexPath.row].0
        cell.valueLabel?.text = genericData[indexPath.row].1
        
        // Set the proper background color
        cell.setDominantColors(with: colors, indexPath: indexPath)
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genericData.count
    }
    
    // MARK: - Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.editMovieSegue {
            let dest = segue.destinationViewController as! ManualEntryTableViewController
            dest.context = .EditMovie
            dest.movieItem = movie!
        }
    }
}

// Drops an shadow around a UIImageView
private extension UIImageView {
    func dropShadow(colored: UIColor? = nil, offset: CGSize = CGSizeMake(0,0), opacity: Float = 1, radius: CGFloat = 1.0) {
        let color = (colored != nil) ? colored!.CGColor : UIColor.blackColor().CGColor
    
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}