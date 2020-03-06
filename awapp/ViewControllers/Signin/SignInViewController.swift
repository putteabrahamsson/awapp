//
//  SignInViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPass: UIButton!
    
    @IBOutlet weak var segment: UISegmentedControl!
    let db = Firestore.firestore()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailTxt: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Run background task
        runBackgroundTask()
        
        //Translating
        translateCode()
        
        //Login user automatically
        automaticLogin()
        
        //Delegating textfields
        email.delegate = self
        password.delegate = self
        
    }
    
    //Translating code
    func translateCode(){
        header.title = NSLocalizedString("login_loginText", comment: "")
        segment.setTitle(NSLocalizedString("login_loginText", comment: ""), forSegmentAt: 0)
        segment.setTitle(NSLocalizedString("login_registerText", comment: ""), forSegmentAt: 1)
        emailTxt.text = NSLocalizedString("email", comment: "")
        passTxt.text = NSLocalizedString("login_password", comment: "")
        loginButton.setTitle(NSLocalizedString("login_loginText", comment: ""), for: .normal)
        forgotPass.setTitle(NSLocalizedString("login_forgot_button", comment: ""), for: .normal)
    }
    
    //Change corner radius and check if it's the users first time
    override func viewDidAppear(_ animated: Bool) {
        loginButton.layer.cornerRadius = 10
        checkIfFirstTime()
    }
    
    //Checking if the user enters the app for the first time.
    func checkIfFirstTime(){
        let defaults = UserDefaults.standard
        //FOR TESTING:defaults.removeObject(forKey: "quickGuide")
        
        if defaults.object(forKey: "quickGuide") == nil{

            //Start welcome tutorial
            if let storyboard = storyboard{
                let vc = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
                
                self.present(vc, animated: true)
            }
        }
        else{
            print("Not the first time")
        }

    }
    
    //Login / Register button
    @IBAction func loginButtonTapped(_ sender: Any){
        if !email.text!.isEmpty || !password.text!.isEmpty{
            if (email.text?.contains("@"))! && (email.text?.contains("."))!{
                if segment.selectedSegmentIndex == 0{
                    signIn()
                }else{
                    signUp()
                }
            }
            else{
                sendAlert(title: NSLocalizedString("alert_ops", comment: ""), message: NSLocalizedString("alert_valid_email", comment: ""))
            }
        }
        else{
            sendAlert(title: NSLocalizedString("alert_ops", comment: ""), message: NSLocalizedString("alert_enter_credentials", comment: ""))
        }
    }
    
    //Forgot password
    @IBAction func resetPassword(_ sender: Any) {
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
            
            self.present(vc, animated: true)
        }
    }
    
    //Login user automatically
    func automaticLogin(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil{
                self.navigateToMain()
            }
        }
    }
    
    //Sign in user
    func signIn(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (result, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                let defaults = UserDefaults.standard
                defaults.set(self.email.text, forKey: "epost")
                self.navigateToMain()
            }
        }
        
    }
    
    //Sign up user
    func signUp(){
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (result, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                print("Succesfully created a new user")
                self.addUserToFirestore()
                self.signIn()
            }
        }
    }
    
    //Navigate to the main viewcontroller
    func navigateToMain(){
        if let storyboard = storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            
            UIApplication.shared.windows.first?.rootViewController = vc
            
            self.present(vc, animated: true)
        }
    }
    
    //Add user to Firestore
    func addUserToFirestore(){
        let authentication = Auth.auth().currentUser?.uid
    db.collection("users").document(authentication!).collection("personal").addDocument(data:
        [
            "email" : email.text!,
            "admin": "0"
    ]) { (err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                print("Succeded adding documents to Firestore")
            }
        }
    }
    
    //Change segment
    @IBAction func changedSegment(_ sender: Any){
        if segment.selectedSegmentIndex == 0{
            header.title = NSLocalizedString("login_loginText", comment: "")
            loginButton.setTitle(NSLocalizedString("login_loginText", comment: ""), for: .normal)
            forgotPass.isHidden = false
            
        }else{
            header.title = NSLocalizedString("login_registerText", comment: "")
            loginButton.setTitle(NSLocalizedString("login_loginText", comment: ""), for: .normal)
            forgotPass.isHidden = true
        }
    }

    
    //Send alert if bad email
    func sendAlert(title: String!, message: String!){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    //Keyboard properties
    @IBAction func closeKeyBoard(_ sender: Any) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Run this task in the background
    func runBackgroundTask(){
        DispatchQueue.global(qos: .background).async {
            self.db.collection("discountCode").getDocuments { (query, err) in
                if let err = err{
                    print(err.localizedDescription)
                }
                else{
                    for documents in query!.documents{
                        let data = documents.data()
                        
                        let expiring = data["expiring"] as? String
                        let documentId = documents.documentID
                        
                        //Getting current date & time
                        let currentDateTime = Date()
                        
                        //Convert string to date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let date = dateFormatter.date(from: expiring!)
                        
                        if date! <= currentDateTime{
                            self.deleteDiscountCodeIfExpired(documentId: documentId)
                        }
                        else{
                            print("Code has not expired")
                        }
                    }
                }
            }
        }
    }
    
    func deleteDiscountCodeIfExpired(documentId: String!){
        db.collection("discountCode").document(documentId).delete { (err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                print("Deleted expired discount code")
            }
        }
    }

}
