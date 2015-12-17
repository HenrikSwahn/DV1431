//
//  MusicDetailViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-08.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class MusicDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewContext, RatingViewDelegate, PlayerPresenter {
    
    // MARK: - Context
    var context = ViewContextEnum.Movie
    var music: Music?
    
    // MARK: - Private Members
    private var data: [[AnyObject]]?
    private var colors: UIImageColors?
    var musicPlayer: AVPlayer?
    
    private struct Storyboard {
        static let mediaDetailTableCellIdentifier = "media detail cell id"
        static let trackCellId = "TrackCellId"
        static let editMusic = "EditMusic"
    }
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var ratingView: UIRatingView!
    
    @IBOutlet weak var titleLabel: UIMarqueeLabel!
    @IBOutlet weak var detailLabel: UIMarqueeLabel!
    
    @IBOutlet weak var tableView: UIStretchableTableView!
    
    
    private func setData() {
        
       /* if let year = music?.releaseYear {
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
        
        musicSpecificData();*/
    }
    
    private func musicSpecificData() {
        /*
        if let albumArtist = music?.albumArtist {
            self.genericData.insert(("Artist: ", albumArtist), atIndex: 0)
        }
        self.genericData.append(("Tracks:", ""))*/
    }

    /*private func updateColor() {
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
    }*/
    
    // MARK: - View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let retrievedMusic = music {
            updateData(retrievedMusic)
        }
    }
    
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
        
        self.ratingView.delegate = self
        
        setData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopMusic()
        self.musicPlayer = nil
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
        case 0, 1:
            if let cell = tableView.dequeueReusableCellWithIdentifier("generalCell", forIndexPath: indexPath) as? GeneralDetailTableViewCell {
                cell.model = data?[indexPath.section][indexPath.row + 1]
                cell.colors = colors
                return cell
            }
            
        case 2:
            if let cell = tableView.dequeueReusableCellWithIdentifier("trackCell", forIndexPath: indexPath) as? TrackTableViewCell {
                cell.model = data?[indexPath.section][indexPath.row + 1]
                cell.colors = colors
                cell.delegate = self
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
    
    // MARK: - Updating
    func updateUI() {
        coverImageView.image = music?.coverArt
        titleLabel.text = music?.title
        titleLabel.type = .LeftRight
        titleLabel.scrollRate = 100.0
        titleLabel.fadeLength = 20.0
        
        detailLabel.text = music?.albumArtist
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
    }
    
    func updateData(music: Music) {
        data = AlbumAdapter.tableView(music)
        tableView.reloadData()
        updateUI()
    }
    
    @IBAction func deleteAction(sender: UIButton) {
        if let item = music {

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
                        set: .Music))
                
                    self.navigationController?.popViewControllerAnimated(true)
                }))
            
            controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - Player presenter
    func playMusic(player: AVPlayer) {
        
        if musicPlayer != nil {
            stopMusic()
        }
        musicPlayer = player
        checkWhosPlaying()
        musicPlayer?.play()
    }
    
    func stopMusic() {
        
        if musicPlayer != nil {
            musicPlayer?.pause()
        }
    }
    
    func checkWhosPlaying() {
        
        for(var i = 0; i < self.tableView.numberOfRowsInSection(AlbumAdapter.getSectionPosition(.Tracks)); i++) {
            let cellOpt = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: AlbumAdapter.getSectionPosition(.Tracks))) as? TrackTableViewCell;
            
            if let cell = cellOpt {
                if cell.player != self.musicPlayer && cell.isPlaying {
                    cell.isPlaying = false
                    cell.updatePreviewButton()
                    break;
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.editMusic {
            if let dest = segue.destinationViewController as? MusicManualEntryViewController {
                dest.context = .EditMovie
                dest.music = music
            }
        }
    }
}