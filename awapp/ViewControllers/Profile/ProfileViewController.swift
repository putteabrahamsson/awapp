//
//  ProfileViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var adminState: String!
    var defaults = UserDefaults.standard
    var email: String!
    
    @IBOutlet weak var header: UINavigationItem!
    
    var sections = [NSLocalizedString("more_s_info", comment: ""),
                    NSLocalizedString("more_s_discount", comment: ""),
                    NSLocalizedString("more_s_invite", comment: ""),
                    NSLocalizedString("more_s_account", comment: ""),
                    NSLocalizedString("more_s_admin", comment: "")]
    
    var btnName =
    [
        [NSLocalizedString("more_b_info", comment: ""),
         NSLocalizedString("more_b_car", comment: "")],
        
        [NSLocalizedString("more_b_discounts", comment: ""),
         NSLocalizedString("more_b_add_discount", comment: "")],
        
        [NSLocalizedString("more_b_invite", comment: ""),
        NSLocalizedString("more_b_facebook", comment: ""),
        NSLocalizedString("more_b_instagram", comment: "")],
        
        [NSLocalizedString("more_b_change_pass", comment: ""),
         NSLocalizedString("more_b_logout", comment: "")],
        
        [NSLocalizedString("more_b_admin", comment: "")]
    ]
    var btnImage =
    [
        [UIImage.init(named: "information"), UIImage.init(named: "car")],
        [UIImage.init(named: "discount"), UIImage.init(named: "discount")],
        [UIImage.init(named: "invite"), UIImage.init(named: "facebook"), UIImage.init(named: "instagram")],
        [UIImage.init(named: "password"), UIImage.init(named: "logout")],
        [UIImage.init(named: "admin")]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateCode()
        
        defaults = UserDefaults.standard
        adminState = defaults.string(forKey: "admin")
        email = defaults.string(forKey: "epost")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func translateCode(){
        header.title = NSLocalizedString("more_header", comment: "")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return btnName[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        cell.buttonName.text = btnName[indexPath.section][indexPath.row]
        cell.buttonImage.image = btnImage[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if adminState == "1"{
            return 45
        }else{
            if section == 4{
                return 0
            }else{
                return 45
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if adminState == "1"{
            return 64
        }else{
            if indexPath == [4,0]{
                return 0
            }else{
                return 64
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deselecting the row
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath {
        case [0,0]:
            navToInfo()
        case [0,1]:
            navToCars()
        case [1,0]:
            navToDiscount()
        case [1,1]:
            navToRedeem()
        case [2,0]:
            shareAppToFriend()
        case [2,1]:
            guard let url = URL(string: "https://www.facebook.com/mekonomengoteborg/") else{return}
            UIApplication.shared.open(url)
        case [2,2]:
            guard let url = URL(string: "https://www.instagram.com/mekonomengoteborg/") else{return}
            UIApplication.shared.open(url)
        case [3,0]:
            changePassword()
        case [3,1]:
            signOut()
        case[4,0]:
            navToAdmin()
        default:
            print("Ingen av dem")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.init(red: 252/255, green: 241/255, blue: 2/255, alpha: 1)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    
    func navToInfo(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "PersonViewController") as! PersonViewController
            
            self.present(vc, animated: true)
        }
    }
    
    func navToCars(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "MyCarsViewController") as! MyCarsViewController
            
            self.present(vc, animated: true)
        }
    }
    
    func navToDiscount(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "DiscountViewController") as! DiscountViewController
            
            self.present(vc, animated: true)
        }
    }
    
    func navToRedeem(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "RedeemViewController") as! RedeemViewController
            
            self.present(vc, animated: true)
        }
    }
    
    func shareAppToFriend(){
        let txt = "Ladda hem Mekonomen Göteborg och ta del av alla super bra erbjudanden!"
        let link = "https://mekonomengoteborg.se/"

        let activityVC = UIActivityViewController(activityItems: [txt, link], applicationActivities: nil)
          
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
          
        activityVC.popoverPresentationController?.sourceView = self.view
          
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func changePassword(){
        let alert = UIAlertController.init(title: NSLocalizedString("profile_alert_title", comment: ""), message: NSLocalizedString("profile_alert_mail", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("profile_alert_change_pass", comment: ""), style: .default, handler: { (action) in
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if let err = err{
                    print(err.localizedDescription)
                }
                else{
                    print("A new password was sent")
                }
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("profile_alert_cancel", comment: ""), style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func signOut(){
        
        let alert = UIAlertController.init(title: NSLocalizedString("profile_alert_title", comment: ""), message: NSLocalizedString("profile_alert_message", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("profile_alert_logout", comment: ""), style: .default, handler: { (action) in
            
                try! Auth.auth().signOut()
                
                //Remove admin userdefault
            self.defaults.set("0", forKey: "admin")

            if let storyboard = self.storyboard{
                    let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    
                    UIApplication.shared.windows.first?.rootViewController = vc
                    
                    self.present(vc, animated: true)
                }
        }))
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("profile_alert_cancel", comment: ""), style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func navToAdmin(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "AdminViewController") as! AdminViewController
            
            self.present(vc, animated: true)
        }
    }
}
