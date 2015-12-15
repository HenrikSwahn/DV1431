//
//  MusicPageViewController.swift
//  Collector
//
//  Created by Dino Opijac on 15/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MusicPageController: MediaPageViewController, ViewContext, FilterDelegate {
    
    // Storyboard
    struct Storyboard {
        // Controller instances
        static let tvc = "MusicTableViewController"
        static let cvc = "MusicCollectionViewController"
        
        // Segues
        static let addMusicSegue = "addMusicSegue"
        static let musicDetailColSegueId = "showMusicDetailCol"
        static let musicDetailTableSegueId = "showMusicDetailTable"
        static let filterMusicSegue = "filterMusicSegue"
    }
    
    // segmentoutlet
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // segmentAction
    @IBAction func segmentAction(sender: UISegmentedControl) {
        shift = sender.selectedSegmentIndex
    }
    
    internal var context = ViewContextEnum.Music
    
    var filter: Filter? {
        didSet {
            if self.filter == nil {
                filteredMusic = music
                self.execute({ $0.reloadData() })
            }
            else {
                filteredMusic = filter!.filterMusic(music!)
                self.execute({ $0.reloadData() })
            }
        }
    }
    
    private var music: [Music]? {
        didSet {
            if self.filter == nil {
                filteredMusic = music
                self.execute({ $0.reloadData() })
            }
            else {
                filteredMusic = filter!.filterMusic(music!);
                self.execute({ $0.reloadData() })
            }
        }
    }
    
    var filteredMusic: [Music]?
    
    // Storage
    private let storage = Storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViewControllers()
        music = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Music), doConvert: true) as? [Music]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        music = storage.searchDatabase(DBSearch(table: nil, searchString: nil, batchSize: nil, set: .Music), doConvert: true) as? [Music]
        
        self.execute({ $0.reloadData() })
    }
    
    override func viewDidChange(index: Int) {
        segmentControl.selectedSegmentIndex = index
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeFilter()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Storyboard.addMusicSegue {
            let navCtr = segue.destinationViewController as! UINavigationController
            let dest = navCtr.topViewController as! SearchEntryTableViewController
            dest.context = context
        }
        /*else if segue.identifier == Storyboard.musicDetailTableSegueId {
            let dest = segue.destinationViewController as! MusicDetailViewController
            let indexPath = self.musicTableView.indexPathForSelectedRow
            dest.music = filteredMusic![(indexPath?.row)!]
            dest.context = context
        }
        else if segue.identifier == Storyboard.musicDetailColSegueId {
            let indexPaths = self.musicCollectionView.indexPathsForSelectedItems()
            if (indexPaths != nil) {
                let indexPath = indexPaths![0]
                let dest = segue.destinationViewController as! MusicDetailViewController
                dest.music = filteredMusic![indexPath.row]
                dest.context = context
            }
        }*/
        else if segue.identifier == Storyboard.filterMusicSegue {
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
    
    // MARK: - Add view controllers
    private func addViewControllers() {
        if let sb = storyboard {
            if let tvc = sb.instantiateViewControllerWithIdentifier(Storyboard.tvc) as? MusicTableViewController {
                tvc.parentController = self
                self.addViewController(tvc)
            }
            
            if let cvc = sb.instantiateViewControllerWithIdentifier(Storyboard.cvc) as? MusicCollectionViewController {
                cvc.parentController = self
                self.addViewController(cvc)
            }
            
            if controllers.count > 0 {
                shift = segmentControl.selectedSegmentIndex
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
