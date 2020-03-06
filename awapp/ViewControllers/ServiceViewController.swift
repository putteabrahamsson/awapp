//
//  ServiceViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-01.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import WebKit

class ServiceViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadWebView() // Do any additional setup after loading the view.
    }
    
    func loadWebView(){
        let url = URL(string: "https://www.mekonomen.se/boka-tid/valj-servicereparation")
        
        webView.load(URLRequest(url: url!))
    }
    

}
