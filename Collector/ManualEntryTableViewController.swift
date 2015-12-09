//
//  ManualEntryTableViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-19.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import MobileCoreServices

class ManualEntryTableViewController: UITableViewController, ViewContext, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Instance variables
    var context = ViewContextEnum.Unkown
    private let movieEntries = ["Age Restriction", "Main Actors", "Director"]
    private let musicEntries = ["Album Artist", "Enter track name", "Track Length"]
    private var tracks = [Track]()
    private var storage = Storage()
    let imagePicker = UIImagePickerController()
    
    private struct Storyboard {
        static let addedTracksCellId = "AddedTracksCell"
    }
    
    @IBOutlet weak var trackTableView: UITableView! {
        didSet {
            self.trackTableView.delegate = self
            self.trackTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var footerView: UIView!
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
        
        switch context {
        case .Movie:
            self.footerView.hidden = true
            self.formatPickerTextField.dataSource(["DVD", "Blu-Ray", "MP4"], arrayTwo: nil, arrayThree: nil)
            break
        case .Music:
            self.footerView.hidden = false
            self.formatPickerTextField.dataSource(["CD", "MP3", "FLAC"], arrayTwo: nil, arrayThree: nil)
            self.runTime.userInteractionEnabled = false
            break
        default:
            break
        }
        
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
        
        var seconds: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (second, _) -> String in return "\(second) s"
        })
        
        var minutes: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (min, _) -> String in return "\(min) m"
        })
        
        var hours: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (hour, _) -> String in return "\(hour) h"
        })
        
        seconds.insert("-", atIndex: 0)
        minutes.insert("-", atIndex: 0)
        hours.insert("-", atIndex: 0)
        
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
        
        if tableView == self.trackTableView {
            return tracks.count
        }
        else {
            switch context {
            case .Movie:
                return movieEntries.count
            case .Music:
                return musicEntries.count
            default:
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.trackTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.addedTracksCellId)
            
            switch context {
            case .Music:
                cell?.textLabel?.text = self.tracks[indexPath.row].name
                cell?.detailTextLabel?.text = self.tracks[indexPath.row].runtime.toString()
                break;
            default:
                break
            }
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("generic entry") as! ManualEntryTableViewCell
            
            switch context {
            case .Movie:
                cell.genricEntryTextField.placeholder = movieEntries[indexPath.row]
                break;
            case .Music:
                
                if indexPath.row == 2 {
                    cell.genricEntryTextField.hidden = true
                    cell.trackRunTime.hidden = false
                }
                else {
                    cell.genricEntryTextField.placeholder = musicEntries[indexPath.row]
                    cell.genricEntryTextField.delegate = self
                    cell.genricEntryTextField.hidden = false
                    cell.trackRunTime.hidden = true
                }
                
                break;
            default:
                break
            }
            return cell
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        let indexPath = NSIndexPath(forRow: 1, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        
        if textField == cell.genricEntryTextField {
            
            switch context {
            case .Music:
                addTrackToGUI(cell)
                break;
            default:
                break;
            }
        }
        return false
    }
    
    private func addTrackToGUI(trackNameCell: ManualEntryTableViewCell) {
        
        let indexPath = NSIndexPath(forRow: 2, inSection: 0)
        let trackLengthCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let name = trackNameCell.genricEntryTextField.text {
            if let length = trackLengthCell.trackRunTime.text {
                let trackRuntime = Runtime.getRuntimeBasedOnFormattedString("0 h " + length)
                if trackRuntime.getTotalInSeconds() > 0 {
                    tracks.append(Track(name: name, runtime: trackRuntime, trackNr: tracks.count+1))
                    trackNameCell.genricEntryTextField.text = nil
                    trackNameCell.genricEntryTextField.placeholder = "Enter track name"
                    trackLengthCell.trackRunTime.setSelectedIndexForComponent(0, component: 0)
                    trackLengthCell.trackRunTime.setSelectedIndexForComponent(0, component: 1)
                    self.trackTableView.reloadData()
                }
                else {
                    let alert = UIAlertController(title: "No valid track length", message: "Enter track length", preferredStyle: .ActionSheet)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .Default) { _ in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - UIImagePickerView
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
