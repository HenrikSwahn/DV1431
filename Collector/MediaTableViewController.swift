//
//  MediaViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-18.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MediaTableViewController: UITableViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView! {
        didSet {
            let gradient = CAGradientLayer()
            gradient.frame = self.backgroundImage.bounds
            let col1 = UIColor.blackColor().CGColor
            let col2 = UIColor.clearColor().CGColor
            gradient.colors = [col1,col2]
            self.backgroundImage.layer.insertSublayer(gradient, atIndex: 0)
        }
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        test.append(("Description", "I motsättning till vad många tror, är inte Lorem Ipsum slumvisa ord. Det har sina rötter i ett stycke klassiskt litteratur på latin från 45 år före år 0, och är alltså över 2000 år gammalt. Richard McClintock, en professor i latin på Hampden-Sydney College i Virginia, översatte ett av de mer ovanliga orden, consectetur, från ett stycke Lorem Ipsum och fann dess ursprung genom att studera användningen av dessa ord i klassisk litteratur. Lorem Ipsum kommer från styckena 1.10.32 och 1.10.33 av \"de Finibus Bonorum et Malorum\" (Ytterligheterna av ont och gott) av Cicero, skriven 45 före år 0. Boken är en avhandling i teorier om etik, och var väldigt populär under renäsanssen. Den inledande meningen i Lorem Ipsum, \"Lorem Ipsum dolor sit amet...\", kommer från stycke 1.10.32. I motsättning till vad många tror, är inte Lorem Ipsum slumvisa ord. Det har sina rötter i ett stycke klassiskt litteratur på latin från 45 år före år 0, och är alltså över 2000 år gammalt. Richard McClintock, en professor i"))
        test.append(("Writers", "Mark Protocevic, Akiva Goldsman"))
        test.append(("Actors", "Will Smith, Alice Braga, Charlie Tahan"))
    }
    
        
    
    private struct Storyboard {
        static let mediaDetailCellId = "media detail cell id"
    }
    
    var test = [(String, String)]()
    
    // MARK: - TableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.mediaDetailCellId) as! MediaDetailTableViewCell
        cell.keyLabel?.text = test[indexPath.row].0
        cell.valueLabel!.text = test[indexPath.row].1
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
}
