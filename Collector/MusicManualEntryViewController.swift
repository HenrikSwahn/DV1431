//
//  MusicManualEntryViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-17.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//
import UIKit
import MobileCoreServices

class MusicManualEntryViewController: UITableViewController,  ViewContext, RatingViewDelegate, PlayerPresenter, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var context = ViewContextEnum.Unkown
    var itunesAlbumItem: ItunesAlbumItem?
    var image: UIImage?
    
    private var data: [[AnyObject]]?
    private var colors: UIImageColors?
    var music: Music?
    private let imagePicker = UIImagePickerController()
    
    private struct Storyboard {
        static let TextInputCell = "TextInputCell"
        static let PickerInputCell = "PickerInputCell"
    }
    
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var ratingView: UIRatingView!
    @IBOutlet weak var titleLabel: UIMarqueeLabel!
    @IBOutlet weak var detailLabel: UIMarqueeLabel!
    @IBOutlet weak var coverArtImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBAction func addMediaToLibraryAction(sender: UIButton) {
        
        if music != nil {
            checkIfMusicNeedsUpdating();
            let storage = Storage()
            
            switch context {
            case .EditMusic:
                storage.updateMusicObject(self.music!)
                break
            case .Music:
                if !storage.storeMusic(self.music!) {
                    alertUser("Album already exists in Media Library")
                }
                break
            default:break
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func checkIfMusicNeedsUpdating() {
        
        
        // Title // Artist // Genre // Location
        var section = 0
        
        for (var row = 0; row < tableView.numberOfRowsInSection(section); row++) {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as? TextInputCell {
            
                switch row {
                case 0:
                    if let input = cell.textInputField.text {
                        music!.title = input
                    }
                    break
                case 1:
                    if let input = cell.textInputField.text {
                        music!.albumArtist = input
                    }
                    break
                case 2:
                    if let input = cell.textInputField.text {
                        music!.genre = input
                    }
                    break
                case 3:
                    if let input = cell.textInputField.text {
                        music!.ownerLocation = input
                    }
                    break
                default:break
                }
            }
        }
        
        section++
        // Type // Format // Release Year
        for (var row = 0; row < tableView.numberOfRowsInSection(section); row++) {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as? PickerTextFieldCell {
            
                switch row {
                case 0:
                    if let input = cell.pickerTextField.text {
                        music!.setOwningType(input)
                    }
                    break
                case 1:
                    if let input = cell.pickerTextField.text {
                        music!.setFormat(input)
                    }
                    break
                case 2:
                    if let input = cell.pickerTextField.text {
                        music!.releaseYear = Int(input)!
                    }
                    break
                default:break
                }
            }
        }
    }
    //MARK: - View Did Load
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let item = itunesAlbumItem {
            requestMusic(item)
        }
        else {
            if let mu = self.music {
                self.updateData(mu)
            }
        }
        
        switch context {
        case .Music: self.AddButton.setTitle("Add to library", forState: .Normal); break
        case .EditMusic: self.AddButton.setTitle("Save changes", forState: .Normal); break
        case .NewMusic: break
        default: break
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
        
        ratingView.delegate = self
        
        //Custom image
        let tap = UITapGestureRecognizer(target: self, action: "imageTapped")
        tap.numberOfTapsRequired = 1
        self.coverArtImage.userInteractionEnabled = true
        self.coverArtImage.addGestureRecognizer(tap)
        self.imagePicker.delegate = self
    }
    
    private func requestMusic(item: ItunesAlbumItem) {
        
        let itunesAlbum = Itunes(resource: ItunesAlbumResource(id: item.id))
        itunesAlbum.request { result in
            switch result {
            case .Success(let response):
                self.music = Music.fromItunesAlbumItem(Itunes.parseAlbum(JSON(response.data))!, albumImage: self.image)
                if let mu = self.music {
                    self.updateData(mu)
                }
                break
            case .Error(_): break
            }
        }
    }
    
    func updateData(music: Music) {
        data = AlbumAdapter.getAddMusicAdapter(music)
        setUpCells()
        tableView.reloadData()
        updateUI()
    }
    
    func updateUI() {
        coverArtImage.image = music?.coverArt
        titleLabel.text = music?.title
        titleLabel.type = .LeftRight
        titleLabel.scrollRate = 100.0
        titleLabel.fadeLength = 20.0
        
        detailLabel.text = music?.genre
        detailLabel.type = .LeftRight
        detailLabel.scrollRate = 100.0
        detailLabel.fadeLength = 20.0
        
        colors = coverArtImage.image?.getColors(coverArtImage.frame.size)
        
        if let color = colors {
            let saturation = color.backgroundColor.colorWithMinimumSaturation(0.1)
            tableView.backgroundColor = saturation
            tableView.separatorColor = color.primaryColor
        }
        
        // Sets the background image to the cover image
        self.backgroundImage.image = self.coverArtImage.image
        
        // Drop a shadow around the cover image
        coverArtImage.dropShadow()
        
        if let rat = self.music?.rating {
            self.ratingView.rating = Float(rat)
        }
    }
    
    //MARK: - Rating view
    func ratingView(ratingView: UIRatingView, didUpdate rating: Float) {
        self.music?.rating = Int(rating)
    }
    
    func ratingView(ratingView: UIRatingView, isUpdating rating: Float) {
        
    }
    
    // MARK: - TableView
    private func setUpCells() {
        var section = 0
        
        for (var row = 0; row < tableView.numberOfRowsInSection(section); row++) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as? TextInputCell
            cell?.model = data![section][row+1]
            cell?.colors = colors
        }
        
        section++
        for (var row = 0; row < tableView.numberOfRowsInSection(section); row++) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as? PickerTextFieldCell
            cell?.context = .Music
            cell?.model = data![section][row+1]
            cell?.colors = colors
        }
    }
    
    // MARK: - Custom Image
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
    
    //MARK: - UIImagePickerView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:AnyObject]){
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.coverArtImage.contentMode = .ScaleAspectFit
        self.coverArtImage.image = chosenImage
        self.coverArtImage.setNeedsDisplay()
        self.music!.coverArt = chosenImage
        self.image = chosenImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func alertUser(msg: String){
        let alert = UIAlertController(title: "Duplicate entries", message: msg, preferredStyle: .ActionSheet)
        let OkAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(OkAction)
        self.presentViewController(alert, animated: true, completion: nil)
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
        let track = Track(name: item.title, runtime: Runtime.getRuntimeBasedOnSeconds(Int(item.duration)!), trackNr: trackIndex, url: item.url)
        return track
    }
}
