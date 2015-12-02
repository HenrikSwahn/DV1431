//
//  ManualEntryTableViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-19.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import CoreData

class ManualEntryTableViewController: UITableViewController, ViewContext {
    
    // MARK: - Instance variables
    var context = ViewContextEnum.Unkown
    private let genericEntries = ["Age Restriction", "Main Actors", "Director"]
    private var storage = Storage()
    
    // MARK: - Outlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var genreFIeld: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var descTextArea: UITextView!
    @IBOutlet weak var releaseYear: UIPickerTextField!
    @IBOutlet weak var owningType: UIPickerTextField!
    @IBOutlet weak var runTime: UIPickerTextField!
    @IBOutlet weak var formatPickerTextField: UIPickerTextField!
    @IBOutlet weak var image: UIImageView!
    
    // MARK: - Actions
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        
        switch context {
        case .Movie:
            addMovie()
            break
        case .Music:
            addMusic()
            break
        default:
            break
        }
    }
    
    // MARK: - Func
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
    
    private func addMovie() {
        
        storage.storeMedia(titleField.text!, genre: genreFIeld.text!, releaseYear: Int(releaseYear.text!)!, owningType: owningType.text, ownerLocation: locationField.text, format: formatPickerTextField.text, runtime: Int(runTime.text!), description: descTextArea.text, coverArt: image.image)
        
        var dynamicData = [String]()
        for(var section = 0; section < self.tableView.numberOfSections; section++) {
            for(var row = 0; row < self.tableView.numberOfRowsInSection(section); row++) {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
                dynamicData.append(cell.genricEntryTextField.text!)
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    private func addMusic() {
        
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatPickerTextField.dataSource(["DVD", "Blu-Ray"])
        self.owningType.dataSource(["Digital", "Physical"])
        
        // Create a array with year range from currentYear - 100 years
        let years: [String] = [Int](count: 100, repeatedValue: 0).mapNumber({
            (year, _) -> String in return "\(2015 - year)"
        })
        
        self.releaseYear.dataSource(years)
        
        let tap = UITapGestureRecognizer(target: self, action: "imageTapped")
        tap.numberOfTapsRequired = 1
        self.image.userInteractionEnabled = true
        self.image.addGestureRecognizer(tap)
        
        let seconds: [String] = [Int](count: 2000, repeatedValue: 0).mapNumber({
            (second, _) -> String in return "\(second)"
        })
        
        self.runTime.dataSource(seconds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return genericEntries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("generic entry") as! ManualEntryTableViewCell
        cell.genricEntryTextField.placeholder = genericEntries[indexPath.row]
        return cell
    }
}

// MARK: - Extensions
extension Array {
    public func mapNumber<T> (f: (Int, Element) -> T) -> [T] {
        return zip((self.startIndex ..< self.endIndex), self).map(f)
    }
}
