//
//  TracksTableViewCell.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-09.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class TracksTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var tracks: [Track]?
    private let cellSeparatorWeight: CGFloat = 0.5
    private struct Storyboard {
        static let trackCellId = "trackCellId"
    }
    
    @IBOutlet weak var tracksTableView: UITableView! {
        didSet {
            self.tracksTableView.delegate = self
            self.tracksTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var tracksLabel: UILabel!
    
    func setData(tracks: [Track]) {
        self.tracks = tracks
        self.tracksTableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.trackCellId)
        cell?.textLabel?.text = tracks![indexPath.row].name
        cell?.detailTextLabel?.text = tracks![indexPath.row].runtime.toString()
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tracks != nil) {
            return tracks!.count
        }
        return 0
    }
    
    private var shadow: UIColor? {
        willSet {
            let shadowLayer = CAGradientLayer()
            shadowLayer.frame = CGRectMake(0, 0, frame.width, 2)
            shadowLayer.colors = [newValue!.CGColor, UIColor.clearColor().CGColor]
            shadowLayer.opacity = 0.5
            contentView.layer.addSublayer(shadowLayer)
        }
    }
    
    func setDominantColors(with colors: UIImageColors?, indexPath: NSIndexPath) {
        if let color = colors {
            backgroundColor = color.secondaryColor
            contentView.backgroundColor = color.secondaryColor
            tracksLabel.textColor = color.detailColor
            
            if indexPath.row == 0 {
                shadow = color.secondaryColor
            } else {
                let separatorView = UIView(frame: CGRectMake(0, 0, self.bounds.width, self.cellSeparatorWeight))
                separatorView.backgroundColor = color.detailColor
                self.contentView.addSubview(separatorView)
            }
        }
    }
}
