//
//  RedeemViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class RedeemViewController: UIViewController, UITextFieldDelegate {

    let db = Firestore.firestore()
    var usedCodes:[String] = []
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var txtfield_discountCode: UITextField!
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var getCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateCode()
        
        txtfield_discountCode.delegate = self

        //Retrieving all the used codes from the user
        if defaults.stringArray(forKey: "usedCodes") != nil{
            usedCodes = defaults.stringArray(forKey: "usedCodes")!
        }
    }
    
    //Setting corner radius of button
    override func viewDidAppear(_ animated: Bool) {
        getCodeButton.layer.cornerRadius = 10
    }
    
    //Translating code
    func translateCode(){
        header.title = NSLocalizedString("redeem_header", comment: "")
        discountCode.text = NSLocalizedString("redeem_enter_code", comment: "")
        getCodeButton.setTitle(NSLocalizedString("redeem_button", comment: ""), for: .normal)
    }
    
    //Get discount code button is tapped
    @IBAction func getDiscountCodeButton(_ sender: Any) {
        getCodeButton.isEnabled = false
        
        guard let validCode = txtfield_discountCode.text else{
            print("Code not entered")
            return
        }
        
        //Retrieve document where discountID
        db.collection("discountCode").whereField("discountID", isEqualTo: validCode).getDocuments(completion: { (query, err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                //Check if the query does exists
                if let validQuery = query, !validQuery.documents.isEmpty{
                    for documents in query!.documents{
                        let data = documents.data()
                        
                        let discountCode = data["discountID"] as? String
                        let percent = data["percent"] as? String
                        let category = data["category"] as? String
                        let expiring = data["expiring"] as? String
                        
                        self.checkIfCodeIsUsed(discountCode: discountCode, percent: percent, category: category, expiring: expiring)
                    }
                }
                //Discount code could not be found
                else{
                    self.sendAlert(title: NSLocalizedString("redeem_alert_title_error", comment: ""), message: NSLocalizedString("redeem_alert_couldnt_find", comment: ""), button: NSLocalizedString("redeem_alert_button_try_again", comment: ""))
                    self.getCodeButton.isEnabled = true
                }
            }
        })
    }
    
    //Check if the code was already used by the user
    func checkIfCodeIsUsed(discountCode: String!, percent: String!, category: String!, expiring: String!){
        
        if self.usedCodes.contains(discountCode!){

            //Send alert if code is already used
            self.sendAlert(title: NSLocalizedString("redeem_alert_title_error", comment: ""), message: NSLocalizedString("redeem_alert_message_used", comment: ""), button: NSLocalizedString("redeem_alert_button_try_again", comment: ""))
            
            //Enable redeem button
            getCodeButton.isEnabled = true
        }
        else{
            //Adding code to used
            usedCodes.append(discountCode!)
            defaults.set(usedCodes, forKey: "usedCodes")
            
            //Adding discount to user
            addDiscountToUser(percent: percent!, category: category!, expiring: expiring!)
        }
    }
    
    //Send alert
    func sendAlert(title: String!, message: String!, button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: button, style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //Adding discount to user if exists / not used
    func addDiscountToUser(percent:String, category:String, expiring:String){
        let authentication = Auth.auth().currentUser?.uid
        db.collection("users").document(authentication!).collection("discount").addDocument(data:
            [
                "category" : category,
                "percent" : percent,
                "expiring" : expiring
        ]) { (err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                
                //Present an alert
                let alert = UIAlertController(title: NSLocalizedString("redeem_alert_title_found", comment: ""), message: NSLocalizedString("redeem_alert_added", comment: ""), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("redeem_alert_button_close", comment: ""), style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true)
            }
        }
    }
    
    //Hide keyboard
    @IBAction func tapToHideKeyboard(_ sender: Any) {
        txtfield_discountCode.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
