//
//  UITableViewCellCacheableImageDelegate.swift
//  Collector
//
//  Created by Dino Opijac on 08/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import UIKit

class UICachableTableViewCell: UITableViewCell {
    // Stores a reference to the delegate
    var delegate: UITableViewCachable?
    
    // Loads an image and applies it to a UIImageView
    // - parameters:
    //      - link: a link to the image
    //      - applyToView: a reference to the UIImageView in which to place the result
    internal func loadImage(link: String, applyToView: UIImageView) {
        // If the image is out of view, but already loaded, set it
        if let image = self.delegate?.cachableTableView(didStore: link) {
            applyToView.image = image
            print("Image Already Exists")
        } else {
            Request().dispatch(Request.Source.URL(NSURL(string: link))) { [unowned self] result in
                switch result {
                case .Error(_): break
                case .Success(let result):
                    // If the image is already loaded in another thread, retrieve it, and set it
                    if let alreadyLoaded = self.delegate?.cachableTableView(didStore: link) {
                        applyToView.image = alreadyLoaded
                        print("ALREADY DOEN")
                    } else {
                        // The image was never loaded, commence the load
                        if let image = UIImage(data: result.data) {
                            print("SET")
                            applyToView.image = image
                            self.delegate?.cachableTableView(willStore: link, image: image)
                        }
                    }
                }
            }
        }
    }
}