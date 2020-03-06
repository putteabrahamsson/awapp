//
//  PageViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-10.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    //Containing viewcontrollers
    lazy var orderedViewControllers: [UIViewController] = {
        return [newVc(viewController: "guide1"),
                newVc(viewController: "guide2"),
                newVc(viewController: "guide3"),
                newVc(viewController: "guide4"),
                newVc(viewController: "guide5")]
    }()
    
    //Page control
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if let firstViewController = orderedViewControllers.first{
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
    }
    
    func newVc(viewController: String) -> UIViewController{
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    //ViewController before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else{
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else{
            return nil
        }
        
        return orderedViewControllers[previousIndex]
        
    }
    
    //ViewController after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else{
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else{
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    //Configure the page control
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.init(red: 252/255, green: 241/255, blue: 2/255, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 252/255, green: 241/255, blue: 2/255, alpha: 1)
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
    }
}
