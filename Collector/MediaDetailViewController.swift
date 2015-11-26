//
//  MediaDetailViewController.swift
//  Collector
//
//  Created by Dino Opijac on 24/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Mockup members
    private var mediaModel = [(String, String)]()
    
    private struct Storyboard {
        static let mediaDetailTableCellIdentifier = "media detail cell id"
    }
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ratingView: UIRatingView!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UIMarqueeLabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var ownerLocationLabel: UILabel!
    @IBOutlet weak var ownerTypeLabel: UILabel!
    
    /*@IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var titleLabel: UIMarqueeLabel!
    @IBOutlet weak var ratingView: UIRatingView!*/
    
    private struct Color {
        static let black = UIColor.blackColor().CGColor
        static let clear = UIColor.clearColor().CGColor
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor.clearColor()
        }
    }
    
    @IBOutlet weak var testimg: UIIconImageView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

/*        let img = testimg.image?.imageWithRenderingMode(.AlwaysTemplate)
        testimg.image = img*/
        
        // Set self as delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        mediaModel.append(("Description", "Years after a plague kills most of humanity and transforms the rest into monsters, the sole survivor in New York City struggles valiantly to find a cure."))
        mediaModel.append(("Writers", "Mark Protocevic, Akiva Goldsman"))
        mediaModel.append(("Actors", "Will Smith, Alice Braga, Charlie Tahan"))
        
        // Mock data for the movie
        self.titleLabel.text = "The Lord of The Rings: Fellowship of the Ring"
        self.yearLabel.text = "2007"
        self.runtimeLabel.text = "1 hour, 40 minutes"
        self.genreLabel.text = "Drama, Sci-Fi, Thriller"
        self.ownerLocationLabel.text = "Physical"
        self.ownerTypeLabel.text = "Blu-Ray"
        
        // Do any additional setup after loading the view.
        self.titleLabel.type = .LeftRight
        self.titleLabel.scrollRate = 100.0
        self.titleLabel.fadeLength = 20.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.shadowLayerOnCover(coverImageView.layer)
        
        let gradient = CAGradientLayer()
        gradient.frame = backgroundView.bounds
        gradient.colors = [Color.clear, Color.black, Color.clear]
        gradient.opacity = 0.5
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func shadowLayerOnCover(layer: CALayer) {
        layer.shadowColor = Color.black
        layer.shadowOffset = CGSizeMake(0, 0)
        layer.shadowOpacity = 1
        layer.shadowRadius = 1.0
    }
    
    // MARK: - TableView delegates
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaDetailTableCellIdentifier) as! MediaDetailTableViewCell
        cell.keyLabel?.text = mediaModel[indexPath.row].0
        cell.valueLabel?.text = mediaModel[indexPath.row].1
        return cell
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaModel.count
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
