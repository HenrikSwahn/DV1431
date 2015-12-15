//
//  FilterTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 30/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, ViewContext {
    
    weak var delegate: FilterDelegate?
    var filter = Filter()
    var context = ViewContextEnum.Unkown
    
    var genresData: [String]?
    var releaseYearsData: [String]?
    var ratingsData: [String]?
    
    @IBOutlet weak var genres: UIPickerView!
    @IBOutlet weak var releaseYear: UIPickerView!
    @IBOutlet weak var ratings: UIPickerView!
   
    @IBAction func didCancel(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        var genre: String?
        var releaseYear: String?
        var rating: String?
        
        if genresData![genres.selectedRowInComponent(0)] != "-" {
            genre = genresData![genres.selectedRowInComponent(0)]
        }
        else {
            genre = nil
        }
        
        if releaseYearsData![self.releaseYear.selectedRowInComponent(0)] != "-" {
            releaseYear = releaseYearsData![self.releaseYear.selectedRowInComponent(0)]
        }
        else {
            releaseYear = nil
        }
        
        if ratingsData![self.ratings.selectedRowInComponent(0)] != "-" {
            rating = ratingsData![self.ratings.selectedRowInComponent(0)]
        }
        else {
            rating = nil
        }
        
        filter.setFilter(genre, year: releaseYear, rating: rating)
        
        if genre == nil && releaseYear == nil && rating == nil {
            delegate?.didSelectFilter(nil)
        }
        else {
            delegate?.didSelectFilter(filter)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    override func viewDidLoad() {
        
        switch context {
        case .Movie:
            setUpForMovie()
            break
        case .Music:
            setUpForMusic()
            break
        default:break
        }
        
        releaseYearsData = [Int](count: 100, repeatedValue: 0).mapNumber({
            (year, _) -> String in return "\(2015 - year)"
        })
        releaseYearsData?.insert("-", atIndex: 0)
        
        releaseYear.dataSource = self
        releaseYear.delegate = self
        
        ratingsData = [String]()
        ratingsData! += ["-","0", "1", "2", "3", "4", "5"]
        ratings.dataSource = self
        ratings.delegate = self
        
        if filter.isActive {
            setRows()
        }
    }
    
    private func setRows() {
        
        if let genre = filter.genre {
            genres.selectRow((genresData?.indexOf(genre))!, inComponent: 0, animated: true)
        }
        
        if let year = filter.year {
            releaseYear.selectRow((releaseYearsData?.indexOf("\(year)"))!, inComponent: 0, animated: true)
        }
        
        if let rating = filter.rating {
            ratings.selectRow((ratingsData?.indexOf("\(rating)"))!, inComponent: 0, animated: true)
        }
    }
    
    private func setUpForMovie() {
        genresData = [String]()
        genresData! += ["-", "Action", "Thriller", "Drama", "Science Fiction","Horror", "Comedy", "Fantasy", "Adventure", "Crime", "Mystery"]
        genres.dataSource = self
        genres.delegate = self
    }
    
    private func setUpForMusic() {
        genresData = [String]()
        genresData! += ["-", "Rock", "Metal", "Classic", "Pop", "Hip-Hop", "Rap", "Hip-Hop/Rap"]
        genres.dataSource = self
        genres.delegate = self
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == genres {
            return genresData!.count
        }
        else if pickerView == releaseYear {
            return releaseYearsData!.count
        }
        else {
            return ratingsData!.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genres {
            return genresData![row]
        }
        else if pickerView == releaseYear {
            return releaseYearsData![row]
        }
        else {
            return ratingsData![row]
        }
    }
}
