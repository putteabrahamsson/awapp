//
//  WheelViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class WheelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        openWebView()
    }
    
    func openWebView(){
       //https://www.timecenter.se/mekonomen/
        
        if let url = NSURL(string: "http://www.123formbuilder.com/form-5137718/my-form"){
            let request = NSURLRequest(url: url)
        }
        
    }

}
