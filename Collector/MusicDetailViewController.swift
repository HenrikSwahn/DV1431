//
//  MusicDetailViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-08.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MusicDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewContext, RatingViewDelegate {
    
    var music: Music?
    var context = ViewContextEnum.Unkown
    
    // MARK: - Private Members
    private var colors: UIImageColors?
    private var genericData = [(String, String)]()
    private struct Storyboard {
        static let mediaDetailTableCellIdentifier = "media detail cell id"
        static let trackCellId = "TrackCellId"
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
        
        if let year = music?.releaseYear {
            self.yearLabel.text = String(year)
        }
        
        if let title = music?.title {
            self.titleLabel.text = title
        }
        
        if let runtime = music?.runtime {
            self.runtimeLabel.text = runtime.toString()
        }
        
        if let genre = music?.genre {
            self.genreLabel.text = genre
        }
        
        if let ownerLocation = music?.ownerLocation {
            self.ownerLocationLabel.text = ownerLocation
        }
        
        if let ownerType = music?.owningType {
            self.ownerTypeLabel.text = ownerType.rawValue
        }
        
        if let coverArt = music?.coverArt {
            self.coverImageView.image = coverArt
        }
        
        if let format = music?.format {
            self.genericData.append(("Format", format.rawValue))
        }
        
        musicSpecificData();
    }
    
    private func musicSpecificData() {
        
        if let albumArtist = music?.albumArtist {
            self.genericData.insert(("Artist: ", albumArtist), atIndex: 0)
        }
        self.genericData.append(("Tracks:", ""))
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
        
        if let rat = self.music?.rating {
            self.ratingView.rating = Float(rat)
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
        
        if let rat = self.music?.rating {
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
        music!.rating = Int(rating)
        storage.updateMusicObject(music!)
    }
    func ratingView(ratingView: UIRatingView, isUpdating rating: Float) {
    
    }
    
    // MARK: - TableView
    private func hideEmptyTableViewCells() {
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row < genericData.count - 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaDetailTableCellIdentifier) as! MediaDetailTableViewCell
            
            cell.keyLabel?.text = genericData[indexPath.row].0
            cell.valueLabel?.text = genericData[indexPath.row].1
            
            // Set the proper background color
            cell.setDominantColors(with: colors, indexPath: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.trackCellId) as! TracksTableViewCell
            
            cell.tracksLabel.text = "Tracks:"
            cell.setData((music?.trackList)!)
            
            // Set the proper background color
            cell.setDominantColors(with: colors, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genericData.count
    }
}