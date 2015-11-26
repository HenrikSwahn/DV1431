//
//  MediaDetailViewController.swift
//  Collector
//
//  Created by Dino Opijac on 24/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    // MARK: - Coloring
    private var colors: UIImageColors?
    
    // MARK: - Mockup members
    private var mediaModel = [(String, String)]()
    
    private struct Storyboard {
        static let mediaDetailTableCellIdentifier = "media detail cell id"
    }
    
    private struct Color {
        static let black = UIColor.blackColor().CGColor
        static let clear = UIColor.clearColor().CGColor
    }
    
    var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var visualView: UIVisualEffectView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UIMarqueeLabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var ownerLocationLabel: UILabel!
    @IBOutlet weak var ownerTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor.clearColor()
        }
    }
    
    @IBOutlet weak var testimg: UIIconImageView!

    private func updateColor() {
        if let c = colors {
            let color = c.primaryColor.isDarkColor ? c.primaryColor : c.backgroundColor

            self.titleLabel.textColor = color
            self.yearLabel.textColor = color
            self.runtimeLabel.textColor = color
            self.genreLabel.textColor = color
            self.ownerLocationLabel.textColor = c.backgroundColor
            self.ownerTypeLabel.textColor = c.backgroundColor
            
            // Separators (borders)
            self.tableView.separatorColor = c.detailColor
        }
    }

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Get the dominantcolor from this image
        let size = self.coverImageView.frame.size
        self.colors = self.coverImageView.image?.getColors(size)
        self.updateColor()
        
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
        
        // Sets the background image to the cover image
        self.backgroundView.image = self.coverImageView.image
        self.headerImageView.image = self.coverImageView.image
        
        h = tableView.tableHeaderView?.frame.size.height
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: h!, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -h!)
        updateHeaderView()
    }
    
    private var h: CGFloat?
    
    func updateHeaderView() {
        var rect = CGRect(x: 0, y: -h!, width: tableView.bounds.width, height: h!)
        if tableView.contentOffset.y < -h! {
            rect.origin.y = tableView.contentOffset.y
            rect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = rect
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        coverImageView.dropShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView delegates
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaDetailTableCellIdentifier) as! MediaDetailTableViewCell

        cell.keyLabel?.text = mediaModel[indexPath.row].0
        cell.valueLabel?.text = mediaModel[indexPath.row].1
        
        // Set the proper background color
        cell.setDominantColors(with: colors, indexPath: indexPath)
        
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

private extension UIImageView {
    func dropShadow(colored: UIColor? = nil, offset: CGSize = CGSizeMake(0,0), opacity: Float = 1, radius: CGFloat = 1.0) {
        if let color = colored {
                layer.shadowColor = color.CGColor
        }
        
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}