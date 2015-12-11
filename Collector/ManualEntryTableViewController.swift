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
    // MARK: - Storage
    private var storage = Storage()
    
    // MARK: - Instance variables
    var context = ViewContextEnum.Unkown
    var tempImage: UIImage?
    
    // MARK: - Movie related
    private let movieEntries = ["Age Restriction", "Main Actors", "Director"]
    var tmdbSearchItem: TMDbSearchItem?
    var movieItem: Movie?
    
    private let musicEntries = ["Album Artist", "Enter track name"]
    private var tracks: [Track]?
    var itunesAlbumItem: ItunesAlbumItem?
    var music: Music?
    
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
    
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch context {
        case .Movie:
            initForMovie()
            break
        case .Music:
            initForMusic()
            break
        case .EditMovie:
            initForMovie()
        default:
            break
        }
        
        initGeneral()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    private func initForMusic() {
        self.footerView.hidden = false
        self.formatPickerTextField.dataSource(["CD", "MP3", "FLAC"], arrayTwo: nil, arrayThree: nil)
        self.runTime.userInteractionEnabled = false
        
        if (itunesAlbumItem != nil) {
            setUpInputsFields()
        }
    }
    
    private func initForMovie() {
        self.footerView.hidden = true
        self.formatPickerTextField.dataSource(["DVD", "Blu-Ray", "MP4"], arrayTwo: nil, arrayThree: nil)
        
        if (tmdbSearchItem != nil) {
            setUpInputsFields()
        }
        else if context == .EditMovie {
            setUpInputsFields()
        }
    }
    
    private func initGeneral() {
        self.owningType.dataSource(["Digital", "Physical"], arrayTwo: nil, arrayThree: nil)
        
        let years: [String] = [Int](count: 100, repeatedValue: 0).mapNumber({
            (year, _) -> String in return "\(2015 - year)"
        })
        
        self.releaseYear.dataSource(years, arrayTwo: nil, arrayThree: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: "imageTapped")
        tap.numberOfTapsRequired = 1
        self.image.userInteractionEnabled = true
        self.image.addGestureRecognizer(tap)
        
        var seconds: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (second, _) -> String in return "\(second)s"
        })
        
        var minutes: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (min, _) -> String in return "\(min)m"
        })
        
        var hours: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (hour, _) -> String in return "\(hour)h"
        })
        
        seconds.insert("-", atIndex: 0)
        minutes.insert("-", atIndex: 0)
        hours.insert("-", atIndex: 0)
        
        self.runTime.dataSource(hours, arrayTwo: minutes, arrayThree: seconds)
        self.imagePicker.delegate = self
    }

    // MARK: - Actions
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        saveMedia()
    }
    
    // MARK: - Add Custom Image
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
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.trackTableView {
            if let t = tracks {
                return t.count
            }
            else {
                return 0
            }
        }
        else {
            switch context {
            case .Movie:
                return movieEntries.count
            case .Music:
                return musicEntries.count
            case .EditMovie:
                return movieEntries.count
            default:
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.trackTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.addedTracksCellId)
            if (tracks != nil) && (context == .Music) {
                cell?.textLabel?.text = tracks![indexPath.row].name
                cell?.detailTextLabel?.text = tracks![indexPath.row].runtime.toString()
            }
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("generic entry") as! ManualEntryTableViewCell
            
            switch context {
            case .Movie:
                if (movieItem == nil) {
                    cell.genricEntryTextField.placeholder = movieEntries[indexPath.row]
                }
                else {
                    switch indexPath.row {
                    case 0:
                        cell.genricEntryTextField.text = "The director" //movieItem.director
                    case 1:
                        cell.genricEntryTextField.text = movieItem?.mainActors
                    case 2:
                        cell.genricEntryTextField.text = "R"            //movieItem?.ageRestriction
                    default:break
                    }
                }
                cell.trackName.hidden = true
                cell.trackRunTime.hidden = true
                cell.addButton.hidden = true
                break;
            case .EditMovie:
                if (movieItem == nil) {
                    cell.genricEntryTextField.placeholder = movieEntries[indexPath.row]
                }
                else {
                    switch indexPath.row {
                    case 0:
                        cell.genricEntryTextField.text = "The director" //movieItem.director
                    case 1:
                        cell.genricEntryTextField.text = movieItem?.mainActors
                    case 2:
                        cell.genricEntryTextField.text = "R"            //movieItem?.ageRestriction
                    default:break
                    }
                }
                cell.trackName.hidden = true
                cell.trackRunTime.hidden = true
                cell.addButton.hidden = true
                break;
            case .Music:
                if indexPath.row == 1 {
                    cell.genricEntryTextField.hidden = true
                    cell.trackRunTime.hidden = false
                    cell.trackRunTime.delegate = self
                    cell.addButton.hidden = false
                    cell.trackName.hidden = false
                    cell.trackName.placeholder = musicEntries[indexPath.row]
                    cell.addButton.addTarget(self, action: "addTrackToGUI:", forControlEvents: .TouchUpInside)
                }
                else {
                    if (itunesAlbumItem == nil) {
                        cell.genricEntryTextField.placeholder = musicEntries[indexPath.row]
                    }
                    else {
                        cell.genricEntryTextField.text = itunesAlbumItem?.artist
                    }
                    
                    cell.genricEntryTextField.delegate = self
                    cell.genricEntryTextField.hidden = false
                    cell.trackRunTime.hidden = true
                    cell.trackName.hidden = true
                    cell.addButton.hidden = true
                }
                
                break;
            default:
                break
            }
            return cell
        }
    }
    
    func addTrackToGUI(sender: UIButton) {
        
        let indexPath = NSIndexPath(forRow: 1, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let name = cell.trackName.text {
            if let length = cell.trackRunTime.text {
                let trackRuntime = Runtime.getRuntimeBasedOnString("0h " + length)
                if trackRuntime.getTotalInSeconds() > 0 {
                    if (tracks == nil) {
                        tracks = [Track]()
                    }
                    tracks!.append(Track(name: name, runtime: trackRuntime, trackNr: tracks!.count+1))
                    cell.trackName.text = nil
                    cell.trackName.placeholder = "Enter track name"
                    cell.trackRunTime.setSelectedIndexForComponent(0, component: 0)
                    cell.trackRunTime.setSelectedIndexForComponent(0, component: 1)
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
    
    //MARK: - Set up inputFields
    private func setUpInputsFields() {
        
        switch self.context {
        case .Music:
            let itunes = Itunes(resource: ItunesAlbumResource(id: itunesAlbumItem!.id))
            itunes.request { result in
                switch result {
                case .Success(let response):
                    let album = Music.fromItunesAlbumItem(Itunes.parseAlbum(JSON(response.data))!, albumImage: self.tempImage)
                    self.titleField.text = album.title
                    self.releaseYear.text = "\(album.releaseYear)"
                    self.genreFIeld.text = album.genre
                    self.descTextArea.text = album.desc
                    self.image.image = album.coverArt
                    self.tracks = album.trackList
                    self.trackTableView.reloadData()
                case .Error(_): break
                }
            }
            break
        case .Movie:
            let tmdb = TMDb(resource: TMDbMovieResource(id: tmdbSearchItem!.id))
            tmdb.request { result in
                switch result {
                case .Success(let response):
                    self.movieItem = Movie.fromTMDbMovieItem(TMDb.parseMovie(JSON(response.data))!, image: self.tempImage)
                    self.titleField.text = self.movieItem!.title
                    self.releaseYear.text = "\(self.movieItem!.releaseYear)"
                    self.genreFIeld.text = self.movieItem!.genre
                    self.descTextArea.text = self.movieItem!.desc
                    self.image.image = self.movieItem!.coverArt
                    self.runTime.text = self.movieItem?.runtime.toString()
                    self.tableView.reloadData()
                  break
                case .Error(_): break
                }
            }
        case .EditMovie:
            self.titleField.text = self.movieItem!.title
            self.releaseYear.text = "\(self.movieItem!.releaseYear)"
            self.genreFIeld.text = self.movieItem!.genre
            self.descTextArea.text = self.movieItem!.desc
            self.image.image = self.movieItem!.coverArt
            self.runTime.text = self.movieItem?.runtime.toString()
            self.tableView.reloadData()
            break
        default:break
        }
    }
    
    //MARK: - Save Music
    private func saveMedia() {
        var success = false
        
        if titleField.text?.characters.count < 0 {
            return
        }
        
        if releaseYear.text?.characters.count < 0 {
            return
        }
        
        if runTime.text?.characters.count < 0 {
            return
        }
        
        switch self.context {
        case .Movie:
            success = movieSpecific()
            break
        case .EditMovie:
            success = movieSpecific()
        case .Music:
            let newMusic = Music(title: titleField.text!, released: Int(releaseYear.text!)!)
            
            if let id = music!.id {
                newMusic.id = id
            }
            if let genre = genreFIeld.text {
                newMusic.genre = genre
            }
            
            if let format = formatPickerTextField.text {
                newMusic.setFormat(format)
            }
            
            if let desc = descTextArea.text {
                newMusic.desc = desc
            }
            
            if let coverArt = image.image {
                newMusic.coverArt = coverArt
            }
            
            if let ownerLocation = locationField.text {
                newMusic.ownerLocation = ownerLocation
            }
            
            if let ownType = owningType.text {
                newMusic.setOwningType(ownType)
            }
            success = musicSpecific(newMusic)
            break
        default:break
        }
        
        if success {
            
            if context == .EditMovie || context == .EditMusic {
                self.navigationController?.popViewControllerAnimated(true)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func movieSpecific() -> Bool {
        
        let movie = Movie(title: titleField.text!, released: Int(releaseYear.text!)!, runtime: Runtime.getRuntimeBasedOnString(runTime.text!))
        
        if let id = movieItem!.id {
            movie.id = id
        }
        
        if let genre = genreFIeld.text {
            movie.genre = genre
        }
        
        if let format = formatPickerTextField.text {
            movie.setFormat(format)
        }
        
        if let desc = descTextArea.text {
            movie.desc = desc
        }
        
        if let coverArt = image.image {
            movie.coverArt = coverArt
        }
        
        if let ownerLocation = locationField.text {
            movie.ownerLocation = ownerLocation
        }
        
        if let ownType = owningType.text {
            movie.setOwningType(ownType)
        }

        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let director = cell.genricEntryTextField.text {
            movie.director = director
        }
        
        indexPath = NSIndexPath(forRow: 1, inSection: 0)
        cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let actors = cell.genricEntryTextField.text {
            movie.mainActors = actors
        }
        
        indexPath = NSIndexPath(forRow: 2, inSection: 0)
        
        // Potential bug
        cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let age = Int(cell.genricEntryTextField.text!) {
            movie.ageRestriction = age
        }
        ////////////////
        
        if context == .EditMovie {
            storage.updateMovieObject(movie)
            return true
        }
        else {
            if !storage.storeMovie(movie) {
                alertUser("Movie already exists in Media Library")
                return false
            }
        }
        return true
    }
    
    private func musicSpecific(music: Music) -> Bool {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ManualEntryTableViewCell
        
        if let albumArtist = cell.genricEntryTextField.text {
            music.albumArtist = albumArtist
        }
        
        if (tracks != nil) {
            music.trackList = tracks!
        }
        
        if !storage.storeMusic(music) {
            alertUser("Album already exists in Media Library")
            return false
        }
        return true
    }
    
    private func alertUser(msg: String){
        let alert = UIAlertController(title: "Duplicate entries", message: msg, preferredStyle: .ActionSheet)
        let OkAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(OkAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension Array {
    public func mapNumber<T> (f: (Int, Element) -> T) -> [T] {
        return zip((self.startIndex ..< self.endIndex), self).map(f)
    }
}

extension Music {
    static func fromItunesAlbumItem(item: ItunesAlbumItem, albumImage: UIImage?) -> Music {
        let music = Music(title: item.name, released: item.release)
        music.albumArtist = item.artist
        music.genre = item.genre
        music.desc = item.description
        music.coverArt = albumImage
        music.id = item.id
        
        
        if let tracks = item.tracks {
            for var i = 0; i < tracks.count; ++i {
                music.insertTrack(Track.fromItunesTrackItem(tracks[i], trackIndex: (i+1)))
            }
        }
        
        return music
    }
}

extension Track {
    static func fromItunesTrackItem(item: ItunesAlbumTrackItem, trackIndex: Int) -> Track {
        let track = Track(name: item.title, runtime: Runtime.getRuntimeBasedOnSeconds(Int(item.duration)!), trackNr: trackIndex)
        return track
    }
}

extension Movie {
    static func fromTMDbMovieItem(item: TMDbMovieItem, image: UIImage?) -> Movie {
        let movie = Movie(title: item.title, released: item.release, runtime: Runtime.getRuntimeBasedOnMinutes(item.runtime))
        movie.id = item.id
        movie.genre = item.genres.joinWithSeparator(", ")
        movie.mainActors = item.cast.joinWithSeparator(", ")
        movie.desc = item.synopsis
        movie.coverArt = image
        
        return movie
    }
}
