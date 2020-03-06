//
//  MyCarsViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class MyCarsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtfield_regPlate: UITextField!
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var addButton: UIButton!
    
    //UserDefaults
    let defaults = UserDefaults.standard
    
    //Array to hold our cars
     var myCars:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateCode()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Adding vehicle defaults to array
        if defaults.object(forKey: "vehicles") != nil{
            myCars = defaults.stringArray(forKey: "vehicles") ?? [String]()
        }
    }
    
    //Chaning corner radius
    override func viewDidAppear(_ animated: Bool) {
        addButton.layer.cornerRadius = 10
    }
    
    //Translate code
    func translateCode(){
        header.title = NSLocalizedString("cars_header", comment: "")
        addButton.setTitle(NSLocalizedString("cars_add", comment: ""), for: .normal)
    }
    
    //Tableview properties
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CarTableViewCell
        
        cell.registrationPlate.text = myCars[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            myCars.remove(at: indexPath.row)
            saveDataIntoUserDefaults()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "CarInfoViewController") as! CarInfoViewController
            
            vc.registrationPlate = myCars[indexPath.row]
            
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //Add a new car
    @IBAction func addNewCar(_ sender: Any) {
        if txtfield_regPlate.text!.isEmpty{
            let alert = UIAlertController.init(title: NSLocalizedString("cars_alert_title", comment: ""), message: NSLocalizedString("cars_alert_message", comment: ""), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }else{
            myCars.append(txtfield_regPlate.text!)
            tableView.reloadData()
            txtfield_regPlate.text = ""
            
            defaults.set(myCars[0], forKey: "currentCar")
            print(myCars[0])
            saveDataIntoUserDefaults()
        }
    }
    
    //Save data in userdefaults
    func saveDataIntoUserDefaults(){
        print("UserDefaults updated")
        defaults.set(myCars, forKey: "vehicles")
    }
    

}
