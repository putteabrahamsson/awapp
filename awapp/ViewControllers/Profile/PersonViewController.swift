//
//  PersonViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var firstnameTxt: UILabel!
    @IBOutlet weak var lastnameTxt: UILabel!
    @IBOutlet weak var emailTxt: UILabel!
    @IBOutlet weak var phoneTxt: UILabel!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var epost: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var saveData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateCode()
        
        //Delegate
        firstName.delegate = self
        lastName.delegate = self
        epost.delegate = self
        phoneNumber.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        retrieveData()
    }
    
    func translateCode(){
        header.title = NSLocalizedString("person_header", comment: "")
        saveButton.title = NSLocalizedString("person_change", comment: "")
        firstnameTxt.text = NSLocalizedString("person_firstname", comment: "")
        lastnameTxt.text = NSLocalizedString("person_lastname", comment: "")
        emailTxt.text = NSLocalizedString("email", comment: "")
        phoneTxt.text = NSLocalizedString("person_phone", comment: "")
    }
    
    //Retrieve data from UserDefaults
    func retrieveData(){
        if defaults.object(forKey: "firstname") != nil{
            firstName.text = defaults.string(forKey: "firstname")
        }
        if defaults.object(forKey: "lastname") != nil{
            lastName.text = defaults.string(forKey: "lastname")
        }
        if defaults.object(forKey: "epost") != nil{
            epost.text = defaults.string(forKey: "epost")
        }
        if defaults.object(forKey: "phone") != nil{
            phoneNumber.text = defaults.string(forKey: "phone")
        }
    }
    //Change data
    @IBAction func changeData(_ sender: Any) {
        if saveData == false{
            saveData = true
            saveButton.title = NSLocalizedString("person_save", comment: "")
            
            firstName.isEnabled = true
            lastName.isEnabled = true
            phoneNumber.isEnabled = true
        }
        else{
            saveData = false
            
            saveButton.title = NSLocalizedString("person_change", comment: "")
            
            firstName.isEnabled = false
            lastName.isEnabled = false
            phoneNumber.isEnabled = false
            
            saveDataIntoUserDefaults()
        }
    }
    
    //Save data
    func saveDataIntoUserDefaults(){
        defaults.set(firstName.text, forKey: "firstname")
        defaults.set(lastName.text, forKey: "lastname")
        defaults.set(phoneNumber.text, forKey: "phone")
        
        self.dismiss(animated: true)
    }
    
    //Keyboard properties
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/3
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func tapToHideKeyboard(_ sender: Any) {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        epost.resignFirstResponder()
        phoneNumber.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
