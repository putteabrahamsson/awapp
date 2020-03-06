//
//  WheelChangeViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-01.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class WheelChangeViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        openWebview()
    }
    
    func openWebview(){
        let url = URL(string: "https://form.jotformeu.com/93044396808364")
        
        webview.load(URLRequest(url: url!))
        
        webview.evaluateJavaScript("document.getElementById('first_3').value") { (data, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                print("test", data)
            }
        }

    }
    

    

    
    
    



}
