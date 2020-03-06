//
//  CarInfoViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-09.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import WebKit

class CarInfoViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var navigationHeader: UINavigationItem!
    
    var registrationPlate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // THIS PAGE IS NOT RELEASED YET 
        navigationHeader.title = registrationPlate
        
    }
}
