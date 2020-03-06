//
//  LastTutorialViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class LastTutorialViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translateCode()
    }
    
    //Translate code
    func translateCode(){
        getStartedButton.setTitle(NSLocalizedString("tutorial_button", comment: ""), for: .normal)
    }
    
    //Changing cornerradius of button when viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        getStartedButton.layer.cornerRadius = 10
    }
    
    //Close the tutorial
    @IBAction func closeTutorial(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "quickGuide")
        
        self.dismiss(animated: true, completion: nil)
    }

}
