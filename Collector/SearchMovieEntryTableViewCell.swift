//
//  SearchMovieEntryTableViewCell.swift
//  Collector
//
//  Created by Dino Opijac on 07/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class SearchMovieEntryTableViewCell: UICachableTableViewCell {
    var model: TMDbSearchItem? {
        didSet {
            updateSelf()
        }
    }
    
    // Identifier from the API
    var identifier: String!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateSelf() {
        if let movie = self.model {
            let link = movie.image
            self.loadImage(link, view: self.movieImage)
            
            identifier = "\(movie.id)"
            titleLabel.text = movie.title
            releaseLabel.text = "\(movie.release)"
            synopsisLabel.text = movie.synopsis
            
        }
    }
}