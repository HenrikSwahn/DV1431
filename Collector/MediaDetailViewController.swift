//
//  MediaDetailViewController.swift
//  Collector
//
//  Created by Dino Opijac on 24/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Private Members
    private var colors: UIImageColors?
    private var media = [(String, String)]()
    private struct Storyboard {
        static let mediaDetailTableCellIdentifier = "media detail cell id"
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

    // MARK: - Mock Data Initialization 
    private func setMockData() {
        // Data for labels
        self.yearLabel.text = "2007"
        self.titleLabel.text = "The Lord of The Rings: Fellowship of the Ring"
        self.runtimeLabel.text = "1 hour, 40 minutes"
        self.genreLabel.text = "Drama, Sci-Fi, Thriller"
        self.ownerLocationLabel.text = "Physical"
        self.ownerTypeLabel.text = "Blu-Ray"
        
        // Data for the table
        media.append(("Description", "Years after a plague kills most of humanity and transforms the rest into monsters, the sole survivor in New York City struggles valiantly to find a cure."))
        media.append(("Writers", "Mark Protocevic, Akiva Goldsman"))
        media.append(("Actors", "Will Smith, Alice Braga, Charlie Tahan"))
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Make table cells resizable
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set mock data
        self.setMockData()
        
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
        

        
        // Hide empty table cells
        self.hideEmptyTableViewCells()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView
    private func hideEmptyTableViewCells() {
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaDetailTableCellIdentifier) as! MediaDetailTableViewCell

        cell.keyLabel?.text = media[indexPath.row].0
        cell.valueLabel?.text = media[indexPath.row].1
        
        // Set the proper background color
        cell.setDominantColors(with: colors, indexPath: indexPath)
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media.count
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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