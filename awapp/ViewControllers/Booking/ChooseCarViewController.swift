//
//  ChooseCarViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-04.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class ChooseCarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var header: UINavigationItem!
    
    var carsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translateCode()
        
        getAllVehicles()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func translateCode(){
        header.title = NSLocalizedString("choose_car_title", comment: "")
    }
    
    
    func getAllVehicles(){
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "vehicles") != nil{
            carsArray = defaults.stringArray(forKey: "vehicles") ?? [String]()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseCar", for: indexPath) as! ChooseCarTableViewCell
        
        cell.registration.text = carsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let car = carsArray[indexPath.row]
        
        let defaults = UserDefaults.standard
        defaults.set(car, forKey: "currentCar")
        
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController


            self.present(vc, animated: false)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

}
