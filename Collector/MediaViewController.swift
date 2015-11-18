//
//  MediaViewController.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-18.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailTable: UITableView! {
        didSet {
            self.detailTable.delegate = self
            self.detailTable.dataSource = self
        }
    }
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var ownerView: UIView! {
        didSet {
            let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.frame = self.ownerView.bounds
            self.ownerView.insertSubview(blurView, atIndex: 0)
        }
    }
    var test = [(String, String)]()
    
    // MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("media detail")
        cell?.textLabel?.text = test[indexPath.row].0
        cell?.detailTextLabel!.text = test[indexPath.row].1
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        test.append(("Hello", "World"))
        // Do any additional setup after loading the view.
    }
}
