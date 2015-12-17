//
//  MovieManualEntryViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-17.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import MobileCoreServices

class MovieManualEntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewContext, RatingViewDelegate, PlayerPresenter, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var context = ViewContextEnum.Unkown
    var tmdbSearchItem: TMDbSearchItem?
    var image: UIImage?
    
    private var data: [[AnyObject]]?
    private var colors: UIImageColors?
    var movie: Movie?
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
    @IBOutlet weak var tableView: UIStretchableTableView!
    
    @IBAction func addMediaToLibraryAction(sender: UIButton) {
        
        if movie != nil {
            checkIfMovieNeedsUpdating();
            let storage = Storage()
            if !storage.storeMovie(movie!) {
                alertUser("Movie already exists in Media Library")
                return
            }

        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func checkIfMovieNeedsUpdating() {
        
        var row = 0, section = 0
        var indexPath = NSIndexPath(forRow: row++, inSection: section)
        
        // Actors
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TextInputCell {
            if let input = cell.textInputField.text {
                if let actors = movie?.mainActors {
                    if input != actors {
                        movie?.mainActors = input
                    }
                }
            }
        }
        
        // Director
        indexPath = NSIndexPath(forRow: row++, inSection: section)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TextInputCell {
            if let input = cell.textInputField.text {
                if let director = movie?.director {
                    if input != director {
                        movie?.director = input
                    }
                }
            }
        }
        
        //Genre
        indexPath = NSIndexPath(forRow: row++, inSection: section)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TextInputCell {
            if let input = cell.textInputField.text {
                if let genre = movie?.genre {
                    if input != genre {
                        movie?.genre = input
                    }
                }
            }
        }
        
        //Location
        //Type
        //Format
        
        //Runtime
        section = 1
        row = 2
        indexPath = NSIndexPath(forRow: row++, inSection: section)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? PickerTextFieldCell {
            if let input = cell.pickerTextField.text {
                if let runtime = movie?.runtime.toString() {
                    if input != runtime {
                        movie?.runtime = Runtime.getRuntimeBasedOnString(input)
                    }
                }
            }
        }
        
        //Release year
        indexPath = NSIndexPath(forRow: row++, inSection: section)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? PickerTextFieldCell {
            if let input = cell.pickerTextField.text {
                if let release = movie?.releaseYear {
                    if input != String(release) {
                        movie?.releaseYear = Int(input)!
                    }
                }
            }
        }
    }
    //MARK: - View Did Load
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let item = tmdbSearchItem {
            requestMovie(item)
        }
        else {
            if let mov = self.movie {
                self.updateData(mov)
            }
        }
        
        switch context {
        case .Movie: self.AddButton.setTitle("Add to library", forState: .Normal); break
        case .EditMovie: self.AddButton.setTitle("Save changes", forState: .Normal); break
        case .NewMovie: break
        default: break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        tableView.userInteractionEnabled = true
        
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
    
    private func requestMovie(item: TMDbSearchItem) {
    
        let tmdb = TMDb(resource: TMDbMovieResource(id: item.id))
        tmdb.request { result in
            switch result {
            case .Success(let response):
                self.movie = Movie.fromTMDbMovieItem(TMDb.parseMovie(JSON(response.data))!, image: self.image)
                if let mov = self.movie {
                    self.updateData(mov)
                }
                break
            case .Error(_): break
            }
        }
    }
    
    func updateData(movie: Movie) {
        data = MovieAdapter.getAddMovieAdapter(movie)
        tableView.reloadData()
        updateUI()
    }
    
    func updateUI() {
        coverArtImage.image = movie?.coverArt
        titleLabel.text = movie?.title
        titleLabel.type = .LeftRight
        titleLabel.scrollRate = 100.0
        titleLabel.fadeLength = 20.0
        
        detailLabel.text = movie?.genre
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
        
        if let rat = self.movie?.rating {
            self.ratingView.rating = Float(rat)
        }
    }
    
    //MARK: - Rating view
    func ratingView(ratingView: UIRatingView, didUpdate rating: Float) {
        self.movie?.rating = Int(rating)
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextInputCell, forIndexPath: indexPath) as? TextInputCell {
                cell.model = data?[indexPath.section][indexPath.row + 1]
                cell.colors = colors
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.PickerInputCell, forIndexPath: indexPath) as? PickerTextFieldCell {
                cell.model = data?[indexPath.section][indexPath.row + 1]
                cell.colors = colors
                return cell
            }
        default:break
        }
        return UITableViewCell()
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
        self.movie!.coverArt = chosenImage
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

extension Movie {
    static func fromTMDbMovieItem(item: TMDbMovieItem, image: UIImage?) -> Movie {
        let movie = Movie(title: item.title, released: item.release, runtime: Runtime.getRuntimeBasedOnMinutes(item.runtime))
        movie.id = item.id
        movie.genre = item.genres.joinWithSeparator(", ")
        movie.mainActors = item.cast.joinWithSeparator(", ")
        movie.desc = item.synopsis
        movie.coverArt = image
        movie.director = item.director
        
        if let videos = item.videos {
            movie.trailers = videos
        }
        
        return movie
    }
}
