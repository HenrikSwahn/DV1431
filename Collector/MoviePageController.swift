//
//  MoviePageController.swift
//  Collector
//
//  Created by Dino Opijac on 14/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MoviePageController: MediaPageViewController, ViewContext, FilterDelegate {
    
    // Storyboard
    struct Storyboard {
        // Controller instantiation
        static let tvc = "MovieTableViewController"
        static let cvc = "MovieCollectionViewController"
        
        // Storyboard segues
        static let addMovieSegueId = "AddMovieSegue"
        static let filterSegue = "filterSegue"
    }
    
    // Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentAction(sender: UISegmentedControl) {
        shift = sender.selectedSegmentIndex
    }
    
    // Context
    internal var context = ViewContextEnum.Movie
    
    //
    private let storage = Storage()
    
    //
    private var movies: [Movie]? {
        didSet {
            if self.filter == nil {
                filteredMovies = movies;
                self.execute({ $0.reloadData() })
            }
            else {
                filteredMovies = filter!.filterMovies(movies!);
                self.execute({ $0.reloadData() })
            }
        }
    }
    
    var filteredMovies: [Movie]?
    var filter: Filter? {
        didSet {
            if self.filter == nil {
                filteredMovies = movies;
                self.execute({ $0.reloadData() })
            }
            else {
                filteredMovies = filter!.filterMovies(movies!);
                self.execute({ $0.reloadData() })
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViewControllers()
        
        movies = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Movie), doConvert: true) as? [Movie]
        self.execute({ $0.reloadData() })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        movies = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Movie), doConvert: true) as? [Movie]
        
        self.execute({ $0.reloadData() })
    }
    
    override func viewDidChange(index: Int) {
        segmentControl.selectedSegmentIndex = index
    }
    
    private func addViewControllers() {
        if let sb = storyboard {
            if let tvc = sb.instantiateViewControllerWithIdentifier(Storyboard.tvc) as? MovieTableViewController {
                tvc.parentController = self
                self.addViewController(tvc)
            }
            
            if let cvc = sb.instantiateViewControllerWithIdentifier(Storyboard.cvc) as? MovieCollectionViewController {
                cvc.parentController = self
                self.addViewController(cvc)
            }
            
            if controllers.count > 0 {
                shift = segmentControl.selectedSegmentIndex
            }
        }
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.addMovieSegueId {
            let navCtr = segue.destinationViewController as! UINavigationController
            let dest = navCtr.topViewController as! SearchEntryTableViewController
            dest.context = context
        }
        else if segue.identifier == Storyboard.filterSegue {
            let dest = segue.destinationViewController as! UINavigationController
            let destTop = dest.topViewController as! FilterTableViewController
            destTop.delegate = self
            destTop.context = context
            
            if filter != nil {
                filter!.isActive = true
                destTop.filter = filter!
            }
        }
    }
    
    // MARK: - Filter Delegate
    func didSelectFilter(filter: Filter?) {
        self.filter = filter
    }
    
    func removeFilter() {
        self.filter = nil
    }
}
