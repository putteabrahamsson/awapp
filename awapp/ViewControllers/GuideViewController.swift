//
//  GuideViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-08.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class GuideViewController: UIPageViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //var images:[String] = ["car", "discount", "information"]
    //var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*pageControl.numberOfPages = images.count
        
        for index in 0..<images.count{
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        
        scrollView.delegate = self */
    }
    
    /*func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    } */


}
