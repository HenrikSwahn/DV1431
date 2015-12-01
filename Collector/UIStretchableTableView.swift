//
//  UIStretchableTableView.swift
//  Collector
//
//  Created by Dino Opijac on 30/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class UIStretchableTableView: UITableView, UIScrollViewDelegate {
    private var headerHeight: CGFloat?
    
    // We need to manage the tableHeaderView
    private var headerView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // We need to check if the table has a tableHeaderView
        if self.tableHeaderView == nil {
            return nil
        }
        
        // Our headerView needs to manage the tableHeaderView
        headerHeight = self.tableHeaderView?.frame.height
        
        if let height = headerHeight {
            headerView = self.tableHeaderView
            tableHeaderView = nil
            addSubview(headerView)
        
            // Change the content offsets/insets so it always sticks to the top
            contentOffset = CGPoint(x: 0, y: -height)
            contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        } else {
            // We could not get the header height
            return nil
        }
    }
    
    // When the table is set and needs layout, we update it
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        if let height = headerHeight {
            var rect = CGRect(x: 0, y: -height, width: self.bounds.width, height: height)
            
            if self.contentOffset.y < -height {
                rect.origin.y = self.contentOffset.y
                rect.size.height = -self.contentOffset.y
            }
            
            headerView?.frame = rect
        }
    }
}
