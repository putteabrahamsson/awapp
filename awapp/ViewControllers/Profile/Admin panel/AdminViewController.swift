//
//  AdminViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-07.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Arrays for section and buttonname
    var sectionName = ["Rabatter", "Administration"]
    var buttonName =
        [
            ["Skanna rabatt QR", "Skapa rabattkod"],
            ["Kommer snart"]
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    //Tableview properties
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonName[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminCell", for: indexPath) as! AdminTableViewCell
        
        cell.buttonName.text = buttonName[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Section 1
        if indexPath == [0, 0]{
            navigateToScanQr()
        }
        if indexPath == [0, 1]{
            navigateToGiveDiscount()
        }
        
        //Section 2
        if indexPath == [1, 0]{
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.init(red: 252/255, green: 241/255, blue: 2/255, alpha: 1)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    
    //Scanning discount QR code
    func navigateToScanQr(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "ScanQrViewController") as! ScanQrViewController
            
            self.present(vc, animated: true)
        }
    }
    
    //Create a new discount code
    func navigateToGiveDiscount(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "GiveDiscountViewController") as! GiveDiscountViewController
            
            self.present(vc, animated: true)
        }
    }
    
}

class AdminTableViewCell: UITableViewCell{
    
    @IBOutlet weak var buttonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
