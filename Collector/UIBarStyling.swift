//
//  UIBarStyling.swift
//  Collector
//
//  Created by Dino Opijac on 17/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class UIBarStyling {    
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
    
    private var tabBar: UITabBar!
    private var navigationBar: UINavigationBar!
    
    init (navigationBar bar1: UINavigationBar?, tabBar bar2: UITabBar?) {
        navigationBar = bar1
        tabBar = bar2
    }
    
    var navigationBarView: UIView? {
        didSet {
            navigationBarView?.addSubview(UIView.separatorMake(.Bottom, rect: navigationBarView!.bounds))
        }
    }
    
    var tabBarSeparatorView: UIView? {
        didSet {
            if tabBarSeparatorView != nil {
                tabBar?.addSubview(tabBarSeparatorView!)
            }
        }
    }
    
    var navigationBarBackgroundColor: UIColor? {
        set {
            if let color = newValue {
                // Store the old barStyle color
                nbStore!.barStyle = navigationBar.barStyle
                
                if color.isDarkColor {
                    navigationBar.barStyle = .Black
                } else {
                    navigationBar.barStyle = .Default
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
            navigationBar.tintColor = newValue
        }
        get {
            return navigationBar.tintColor
        }
    }
    
    var tabBarBackgroundColor: UIColor? {
        didSet {
            tabBar.backgroundColor = tabBarBackgroundColor
        }
    }
    var tabBarSeparatorColor: UIColor? {
        didSet {
            tabBarSeparatorView?.backgroundColor = tabBarSeparatorColor
        }
    }
    var tabBarTintColor: UIColor? {
        didSet {
            tabBar.tintColor = tabBarTintColor
        }
    }
    
    func viewWillAppear(animated: Bool) {
            navigationBarView = UIView(frame: CGRectMake(0, -20, UIScreen.mainScreen().bounds.size.width, CGRectGetHeight(navigationBar.bounds)+20))
            navigationBarView!.userInteractionEnabled = false
            navigationBarView!.backgroundColor = UIColor.clearColor()
            
            nbStore = Bar(bar: navigationBar)
            
            // Make our changes
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: nbStore!.metrics)
            navigationBar.shadowImage = UIImage()
            navigationBar.backgroundColor = UIColor.clearColor()
            navigationBar.translucent = true
            navigationBar.insertSubview(navigationBarView!, atIndex: 0)
        
            tbStore = Bar(bar: tabBar)
            
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
            
            // Create the border
            tabBarSeparatorView = UIView.separatorMake(.Top, rect: tabBar.bounds)
    }
    
    func viewWillDisappear(animated: Bool) {
            // Restore all changes
            navigationBarView?.removeFromSuperview()
            
            navigationBar.setBackgroundImage(nbStore!.backgroundImage, forBarMetrics: nbStore!.metrics)
            
            navigationBar.backgroundColor = nbStore!.backgroundColor
            navigationBar.shadowImage = nbStore!.shadowImage
            navigationBar.tintColor = nbStore!.tintColor
            
            if let translucent = nbStore!.translucency {
                navigationBar.translucent = translucent
            }
            
            if let barStyle = nbStore!.barStyle {
                navigationBar.barStyle = barStyle
            }
        
            tabBarSeparatorView?.removeFromSuperview()
            
            tabBar.tintColor = tbStore!.tintColor
            tabBar.backgroundImage = tbStore!.backgroundImage
            tabBar.shadowImage = tbStore!.shadowImage
            tabBar.backgroundColor = tbStore!.backgroundColor
    }
}