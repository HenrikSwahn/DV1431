//
//  UIBarStyleController.swift
//  Collector
//
//  Created by Dino Opijac on 17/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

// Do not use this view controller
@available(*, deprecated)
class UIBarStyleController: UIViewController {
    
    private struct Bar {
        let metrics: UIBarMetrics = .Default
        var backgroundImage: UIImage?
        var shadowImage: UIImage?
        var translucency: Bool?
        var backgroundColor: UIColor?
        var tintColor: UIColor?
        var barStyle: UIBarStyle?
        
        init(bar: UINavigationBar) {
            backgroundImage = bar.backgroundImageForBarMetrics(metrics)
            shadowImage     = bar.shadowImage
            backgroundColor = bar.backgroundColor
            translucency    = bar.translucent
            tintColor       = bar.tintColor
        }
        
        init(bar: UITabBar) {
            tintColor = bar.tintColor
            backgroundImage = bar.backgroundImage
            shadowImage = bar.shadowImage
            backgroundColor = bar.backgroundColor
        }
    }
    
    private var nbStore: Bar?
    private var tbStore: Bar?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var navigationBarView: UIView? {
        didSet {
            navigationBarView?.addSubview(UIView.separatorMake(.Bottom, rect: navigationBarView!.bounds))
        }
    }
    
    var tabBarSeparatorView: UIView? {
        didSet {
            if tabBarSeparatorView != nil {
                tabBarController?.tabBar.addSubview(tabBarSeparatorView!)
            }
        }
    }
    
    var navigationBarBackgroundColor: UIColor? {
        set {
            if let color = newValue {
                // Store the old barStyle color
                nbStore!.barStyle = navigationController?.navigationBar.barStyle
                
                if color.isDarkColor {
                    navigationController?.navigationBar.barStyle = .Black
                } else {
                    navigationController?.navigationBar.barStyle = .Default
                }
                
                navigationBarView?.backgroundColor = color
            }
            
        }
        
        get {
            return navigationBarView?.backgroundColor
        }
    }
    
    var navigationBarSeparator: UIView? {
        get {
            return navigationBarView?.subviews[0]
        }
    }
    
    var navigationBarTintColor: UIColor? {
        set {
            navigationController?.navigationBar.tintColor = newValue
        }
        get {
            return navigationController?.navigationBar.tintColor
        }
    }
    
    var tabBarBackgroundColor: UIColor? {
        didSet {
            tabBarController?.tabBar.backgroundColor = tabBarBackgroundColor
        }
    }
    var tabBarSeparatorColor: UIColor? {
        didSet {
            tabBarSeparatorView?.backgroundColor = tabBarSeparatorColor
        }
    }
    var tabBarTintColor: UIColor? {
        didSet {
            tabBarController?.tabBar.tintColor = tabBarTintColor
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ctrlr = navigationController {
            navigationBarView = UIView(frame: CGRectMake(0, -20, UIScreen.mainScreen().bounds.size.width, CGRectGetHeight(ctrlr.navigationBar.bounds)+20))
            navigationBarView!.userInteractionEnabled = false
            navigationBarView!.backgroundColor = UIColor.clearColor()
            
            nbStore = Bar(bar: ctrlr.navigationBar)
            
            // Make our changes
            ctrlr.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: nbStore!.metrics)
            ctrlr.navigationBar.shadowImage = UIImage()
            ctrlr.navigationBar.backgroundColor = UIColor.clearColor()
            ctrlr.navigationBar.translucent = true
            ctrlr.navigationBar.insertSubview(navigationBarView!, atIndex: 0)
        }
        
        if let tbctrlr = tabBarController {
            tbStore = Bar(bar: tbctrlr.tabBar)
            
            tbctrlr.tabBar.backgroundImage = UIImage()
            tbctrlr.tabBar.shadowImage = UIImage()
            
            // Create the border
            tabBarSeparatorView = UIView.separatorMake(.Top, rect: tbctrlr.tabBar.bounds)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if navigationController != nil {
            // Restore all changes
            navigationBarView?.removeFromSuperview()
            
            navigationController?.navigationBar.setBackgroundImage(nbStore!.backgroundImage, forBarMetrics: nbStore!.metrics)
            
            navigationController?.navigationBar.backgroundColor = nbStore!.backgroundColor
            navigationController?.navigationBar.shadowImage = nbStore!.shadowImage
            navigationController?.navigationBar.tintColor = nbStore!.tintColor
            
            if let translucent = nbStore!.translucency {
                navigationController?.navigationBar.translucent = translucent
            }
            
            if let barStyle = nbStore!.barStyle {
                navigationController?.navigationBar.barStyle = barStyle
            }
        }
        
        if tabBarController != nil {
            tabBarSeparatorView?.removeFromSuperview()
            
            tabBarController?.tabBar.tintColor = tbStore!.tintColor
            tabBarController?.tabBar.backgroundImage = tbStore!.backgroundImage
            tabBarController?.tabBar.shadowImage = tbStore!.shadowImage
            tabBarController?.tabBar.backgroundColor = tbStore!.backgroundColor
        }
        
    }
}