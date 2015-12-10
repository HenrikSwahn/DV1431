//
//  SearchMusicEntryTableViewCell.swift
//  Collector
//
//  Created by Dino Opijac on 07/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class SearchMusicEntryTableViewCell: UICachableTableViewCell {
    var model: ItunesAlbumItem? {
        didSet {
            updateSelf()
        }
    }
    
    var identifier: String!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    private func updateSelf() {
        if let album = self.model {
            let link = album.image
            //let link = "http://app.opij.ac/image.jpg"
            self.loadImage(link!, view: self.albumImage)
            
            identifier = album.id
            releaseLabel.text = "\(album.release)"
            artistLabel.text = album.artist
            titleLabel.text = album.name
        }
    }
}
