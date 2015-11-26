//
//  SearchTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 19/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

@IBDesignable
class SearchTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Variables and constances
    private struct Storyboard {
            static let mediaCellId = "media cell"
    }
    
    private var media = [Media]()
    
    @IBOutlet weak var movieTableCell: UITableViewCell!
    @IBOutlet weak var musicTableCell: UITableViewCell!

    @IBOutlet weak var movieResultsCollectionView: UICollectionView! {
        didSet {
            self.movieResultsCollectionView.delegate = self
            self.movieResultsCollectionView.dataSource = self
        }
    }

    @IBOutlet weak var musicResultsCollectionView: UICollectionView! {
        didSet {
            self.musicResultsCollectionView.delegate = self
            self.musicResultsCollectionView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let mov1 = Media(title: "I am Legend", released: 2007, runtime: Runtime(hours: 1, minutes: 40, seconds: 40))
        let mov2 = Media(title: "I am Legend", released: 2007, runtime: Runtime(hours: 1, minutes: 40, seconds: 40))
        let mov3 = Media(title: "I am Legend", released: 2007, runtime: Runtime(hours: 1, minutes: 40, seconds: 40))
        let mov4 = Media(title: "I am Legend", released: 2007, runtime: Runtime(hours: 1, minutes: 40, seconds: 40))
        
        media += [mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4,mov1, mov2, mov3, mov4]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

 /*   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.mediaCellId, forIndexPath: indexPath) as! MediaCollectionViewCell
        cell.titleLabel.text = media[indexPath.row].getTitle()
        cell.releaseYearLabel.text = "\(media[indexPath.row].getReleaseYear())"
        cell.coverArt.image = media[indexPath.row].getCoverArt()

        return cell
    }

    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
