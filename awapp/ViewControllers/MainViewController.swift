//
//  MainViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registrationPlate: UILabel!
    var currentCar: String?
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var selectedCar: UILabel!
    @IBOutlet weak var changeCarButton: UIButton!
    
    let db = Firestore.firestore()
    
    var buttonArray:[String] = [NSLocalizedString("main_book_service", comment: ""),NSLocalizedString("main_book_wheel", comment: ""),NSLocalizedString("main_book_call", comment: ""),NSLocalizedString("main_book_mail", comment: "")]
    
    var buttonImg:[UIImage] = [
        UIImage.init(named: "bookservice")!,
        UIImage.init(named: "bookwheel")!,
        UIImage.init(named: "bookbyphone")!,
        UIImage.init(named: "bookbymail")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translateCode()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getAllVehicles()
        
        runBackgroundTask()
    }
    
    func translateCode(){
        header.title = NSLocalizedString("main_header", comment: "")
        selectedCar.text = NSLocalizedString("main_selected_car", comment: "")
        changeCarButton.setTitle(NSLocalizedString("main_change_car", comment: ""), for: .normal)
        
        if let tabItem = self.tabBarController?.tabBar.items{
            tabItem[0].title = NSLocalizedString("tab1", comment: "")
            tabItem[1].title = NSLocalizedString("tab2", comment: "")
            tabItem[2].title = NSLocalizedString("tab3", comment: "")
        }
    }
    
    func getAllVehicles(){
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "currentCar") != nil{
            currentCar = defaults.string(forKey: "currentCar")
            
            registrationPlate.text = currentCar
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return buttonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        cell.imageBox.image = buttonImg[indexPath.row]
        cell.buttonName.text = buttonArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath{
        case [0, 0]:
            navigateToService()
        case [0, 1]:
            navigateToWheelChange()
        case [0, 2]:
            bookViaCall()
        case [0, 3]:
            bookUsingMail()
        default:
            print("Not an alternative!")
        }
    }

    @IBAction func changeCurrentCar(_ sender: Any) {
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "ChooseCarViewController") as! ChooseCarViewController

            self.present(vc, animated: true)
        }
    }
    
    //Navigating to booksystem for service/reperation
    func navigateToService(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "BookServiceViewController") as! BookServiceViewController
            
            self.present(vc, animated: true)
        }
    }
    
    //Navigating to booksystem for wheelchange
    func navigateToWheelChange(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "BookWheelViewController") as! BookWheelViewController
            
            self.present(vc, animated: true)
        }
    }
    
    //Call to book
    func bookViaCall(){
        let phoneNumber = "031579180";
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    func bookUsingMail(){
        let email = "info@awverkstad.se"
        
        if let mail = URL(string: "mailto:\(email)"){
            
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(mail)){
                if #available(iOS 10.0, *) {
                    application.open(mail, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(mail as URL)
                }
            }
        }
    }
    
    //Delete discount if expired in the background
    func runBackgroundTask(){
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            let authentication = Auth.auth().currentUser?.uid
            
            self.db.collection("users").document(authentication!).collection("discount").getDocuments { (query, err) in
                if let err = err{
                    print(err.localizedDescription)
                }
                else{
                    for documents in query!.documents{
                        let data = documents.data()
                        
                        let expiring = data["expiring"] as? String
                        let documentId = documents.documentID
                        
                        //Get current datetime
                        let currentDateTime = Date()
                        
                        //Convert string to date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let date = dateFormatter.date(from: expiring!)
                        
                        if date! <= currentDateTime{
                            //delete document if expired
                            self.deleteDiscountIfExpired(documentID: documentId)
                        }
                        else{
                            print("Not expired")
                        }
                    }
                }
            }
        }
    }
    
    func deleteDiscountIfExpired(documentID: String!){
        let authentication = Auth.auth().currentUser?.uid
        self.db.collection("users").document(authentication!).collection("discount").document(documentID).delete { (err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                print("Successfully deleted discount code")
            }
        }
    }
    
}

class MainTableViewCell: UITableViewCell{
    
    @IBOutlet weak var imageBox: UIImageView!
    @IBOutlet weak var buttonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

