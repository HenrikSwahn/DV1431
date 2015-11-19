//
//  ManualEntryTableViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-19.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class ManualEntryTableViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet weak var releaseYear: UIPickerTextField! {
        didSet {
            // Create a array with year range from currentYear - 100 years
            let years: [String] = [Int](count: 100, repeatedValue: 0).mapNumber({
                (year, _) -> String in return "\(2015 - year)"
            })
            
            self.releaseYear.dataSource(years)
        }
    }
    @IBOutlet weak var image: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: "imageTapped")
            tap.numberOfTapsRequired = 1
            self.image.userInteractionEnabled = true
            self.image.addGestureRecognizer(tap)
        }
    }
    
    func imageTapped() {
        
        let menu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: nil) //Should take some function
        let photoAlbumAction = UIAlertAction(title: "Photo Album", style: .Default, handler: nil) //Should take some function
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil) //Should take some function
        
        menu.addAction(cameraAction)
        menu.addAction(photoAlbumAction)
        menu.addAction(cancelAction)
        
        self.presentViewController(menu, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

// MARK: - Extensions
extension Array {
    public func mapNumber<T> (f: (Int, Element) -> T) -> [T] {
        return zip((self.startIndex ..< self.endIndex), self).map(f)
    }
}
