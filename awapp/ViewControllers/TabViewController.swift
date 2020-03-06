//
//  TabViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class TabViewController: UITabBarController {
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil{
            getDataFromFirestore()
        }
    }

    
    func getDataFromFirestore(){
        let authentication = Auth.auth().currentUser?.uid
        db.collection("users").document(authentication!).collection("personal").getDocuments { (query, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                for document in query!.documents{
                    let data = document.data()
                    
                    let admin = data["admin"] as? String
                    
                    let defaults = UserDefaults.standard
                    defaults.set(admin, forKey: "admin")
                }
            }
        }
    }
    
}
