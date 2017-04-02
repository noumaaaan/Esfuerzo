//
//  ExplorePagingViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 31/03/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class ExplorePagingViewController: UIPageViewController, UIPageViewControllerDataSource {

    // Lazy array to instantiate the views
    lazy var viewControllerList : [UIViewController] = {
        let sb = UIStoryboard(name:"Main", bundle:nil)
        
        let view1 = sb.instantiateViewController(withIdentifier: "Red1")
        let view2 = sb.instantiateViewController(withIdentifier: "Blue1")
        let view3 = sb.instantiateViewController(withIdentifier: "Green1")
        let view4 = sb.instantiateViewController(withIdentifier: "Pink1")
       
        return [view1, view2, view3, view4]
    }()
    
    // Function run when the view loads for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstViewController = viewControllerList.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else {
            return nil
        }
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        return viewControllerList[nextIndex]
    }

    
    
}
