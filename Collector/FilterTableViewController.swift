//
//  FilterTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 30/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    @IBAction func didCancel(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
