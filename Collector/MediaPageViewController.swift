//
//  MediaPageController.swift
//  Collector
//
//  Created by Dino Opijac on 14/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

protocol MediaPageControllerDelegate {
    var parentController: MediaPageViewController? { get set }
    func reloadData()
    
    @available(*, deprecated)
    func indexPaths() -> [NSIndexPath]?
}

class MediaPageViewController:
    UIPageViewController,
    UIPageViewControllerDelegate,
    UIPageViewControllerDataSource {
    
    // Private Members
    var controllers = [UIViewController]()

    var pageIndex: Int = 0
    
    var controller: MediaPageControllerDelegate? {
        get {
            if let ctrlr = controllers[pageIndex] as? MediaPageControllerDelegate {
                return ctrlr
            }
            
            return nil
        }
    }
    
    func execute(completion: (MediaPageControllerDelegate) -> Void) {
        controllers.forEach { controller in
            if let ctrl = controller as? MediaPageControllerDelegate {
                completion(ctrl)
            }
        }
    }
    
    var shift: Int? {
        didSet {
            if let index = shift {
                setViewControllers([controllers[index]],
                    direction:  viewControllerDirection(index),
                    animated:   true,
                    completion: nil
                )
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: - PageView DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return presentController(viewController, state: .Reverse)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return presentController(viewController, state: .Forward)
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if let index = controllers.indexOf(pendingViewControllers[0]) {
            pageIndex = index
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            viewDidChange(pageIndex)
        }
    }
    
    func addViewController(controller: UIViewController) {
        controllers.append(controller)
    }
    
    private func presentController(currentViewController: UIViewController, state: UIPageViewControllerNavigationDirection) -> UIViewController? {
        if let index = controllers.indexOf(currentViewController) {
            switch state {
            case .Forward:
                guard index != 0 else { return nil }
                return viewControllerAtIndex(index - 1)
            case .Reverse:
                guard index != controllers.count - 1 else { return nil }
                return viewControllerAtIndex(index + 1)
            }
        }
        
        return nil
    }
    
    private func viewControllerAtIndex(index: Int) -> UIViewController? {
        guard index >= 0 else { return nil }
        guard index <= (controllers.count - 1) else { return nil }
        return controllers[index]
    }
    
    private func viewControllerDirection(index: Int) -> UIPageViewControllerNavigationDirection {
        let leftDistance = index
        let rightDistance = (controllers.count - 1) - index
        
        return leftDistance > rightDistance ? .Forward : .Reverse
    }
    
    // Override
    func viewDidChange(index: Int) {}
}
