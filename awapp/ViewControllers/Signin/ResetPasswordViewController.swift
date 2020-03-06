//
//  ResetPasswordViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-10.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var emailTxt: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translateCode()
        
        email.delegate = self
    }
    
    //Chaning corner radius
    override func viewDidAppear(_ animated: Bool) {
        resetButton.layer.cornerRadius = 10
    }
    
    //Translating the code
    func translateCode(){
        header.title = NSLocalizedString("reset_password", comment: "")
        emailTxt.text = NSLocalizedString("email", comment: "")
        resetButton.setTitle(NSLocalizedString("reset_password", comment: ""), for: .normal)
    }
    
    //Reset password button tapped
    @IBAction func resetPasswordTapped(_ sender: Any) {
        if !email.text!.isEmpty{
            if (email.text?.contains("@"))! && (email.text?.contains("."))!{
                auth.sendPasswordReset(withEmail: email.text!) { (err) in
                    if let err = err{
                        print(err.localizedDescription)
                    }
                    else{
                        print("A new password has been sent!")
                    }
                }
            }
            else{
                sendAlert()
            }
        }
        else{
            sendAlert()
        }
    }
    
    //Send alert to user
    func sendAlert(){
        let alert = UIAlertController.init(title: NSLocalizedString("alert_ops", comment: ""), message: NSLocalizedString("alert_valid_email", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //Keyboard properties
    @IBAction func tapToDismissKeyboard(_ sender: Any) {
        email.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

}
