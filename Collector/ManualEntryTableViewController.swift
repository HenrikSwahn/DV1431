//
//  ManualEntryTableViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-19.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import MobileCoreServices

class ManualEntryTableViewController: UITableViewController, ViewContext, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Instance variables
    var context = ViewContextEnum.Unkown
    private let genericEntries = ["Age Restriction", "Main Actors", "Director"]
    private var storage = Storage()
    let imagePicker = UIImagePickerController()
    
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
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .Camera
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoAlbumAction = UIAlertAction(title: "Photo Album", style: .Default) { _ in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil) //Should take some function
        
        menu.addAction(cameraAction)
        menu.addAction(photoAlbumAction)
        menu.addAction(cancelAction)
        
        self.presentViewController(menu, animated: true, completion: nil)
        
    }
    
    private func addMovie() {
        
        if titleField.text?.characters.count < 0 {
            return
        }
        
        if releaseYear.text?.characters.count < 0 {
            return
        }
        
        if runTime.text?.characters.count < 0 {
            return
        }
        
        let newMovie = Movie(title: titleField.text!, released: Int(releaseYear.text!)!, runtime: Runtime.getRuntimeBasedOnFormattedString(runTime.text!))
        
        if let genre = genreFIeld.text {
            newMovie.genre = genre
        }
        
        if let format = formatPickerTextField.text {
            newMovie.setFormat(format)
        }
        
        if let desc = descTextArea.text {
            newMovie.desc = desc
        }
        
        if let coverArt = image.image {
            newMovie.coverArt = coverArt
        }
        
        if let ownerLocation = locationField.text {
            newMovie.ownerLocation = ownerLocation
        }
        
        if let ownType = owningType.text {
            newMovie.setOwningType(ownType)
        }
        
        /* Generic data */
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let age = Int(cell.genricEntryTextField.text!) {
                newMovie.ageRestriction = age
        }
        
        indexPath = NSIndexPath(forRow: 1, inSection: 0)
        cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let actors = cell.genricEntryTextField.text {
            newMovie.mainActors = actors
        }
        
        indexPath = NSIndexPath(forRow: 2, inSection: 0)
        cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let director = cell.genricEntryTextField.text {
            newMovie.director = director
        }
        storage.storeMovie(newMovie)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func addMusic() {
        
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatPickerTextField.dataSource(["DVD", "Blu-Ray"], arrayTwo: nil, arrayThree: nil)
        self.owningType.dataSource(["Digital", "Physical"], arrayTwo: nil, arrayThree: nil)
        
        // Create a array with year range from currentYear - 100 years
        let years: [String] = [Int](count: 100, repeatedValue: 0).mapNumber({
            (year, _) -> String in return "\(2015 - year)"
        })
        
        self.releaseYear.dataSource(years, arrayTwo: nil, arrayThree: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: "imageTapped")
        tap.numberOfTapsRequired = 1
        self.image.userInteractionEnabled = true
        self.image.addGestureRecognizer(tap)
        
        let seconds: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (second, _) -> String in return "\(second) s"
        })
        
        let minutes: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (min, _) -> String in return "\(min) m"
        })
        
        let hours: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (hour, _) -> String in return "\(hour) h"
        })
        
        self.runTime.dataSource(hours, arrayTwo: minutes, arrayThree: seconds)
        
        self.imagePicker.delegate = self
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
    
    //MARK: UIImagePickerView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:AnyObject]){
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image.contentMode = .ScaleAspectFit
        image.image = chosenImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Extensions
extension Array {
    public func mapNumber<T> (f: (Int, Element) -> T) -> [T] {
        return zip((self.startIndex ..< self.endIndex), self).map(f)
    }
}
