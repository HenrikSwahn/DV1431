//
//  MediaPageControllerDelegate.swift
//  Collector
//
//  Created by Dino Opijac on 15/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

protocol MediaPageControllerDelegate {
    var parentController: MediaPageViewController? { get set }
    func reloadData()
}