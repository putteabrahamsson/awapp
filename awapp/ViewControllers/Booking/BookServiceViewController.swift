//
//  BookServiceViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import WebKit

class BookServiceViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var bookingView: WKWebView!
    @IBOutlet weak var header: UINavigationItem!
    
    var location: String!
    
    var firstname: String!
    var lastname: String!
    var email: String!
    var phone: String!
    var selectedCar: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateCode()
        
        bookingView.navigationDelegate = self
        
        retrieveData()
        openWebView()
    }
    
    func translateCode(){
        header.title = NSLocalizedString("service_header", comment: "")
    }
    
    func openWebView(){
        if let url = NSURL(string: "https://www.mekonomen.se/boka-tid/valj-servicereparation"){
             let request = NSURLRequest(url: url as URL)
             
             bookingView.load(request as URLRequest)
         }
    }
    
    //Retrieve data from UserDefaults
    func retrieveData(){
        
        let defaults = UserDefaults.standard
        
        firstname = defaults.string(forKey: "firstname") ?? ""
        lastname = defaults.string(forKey: "lastname") ?? ""
        email = defaults.string(forKey: "epost") ?? ""
        phone = defaults.string(forKey: "phone") ?? ""
        selectedCar = defaults.string(forKey: "currentCar") ?? ""
    }
    
    //Handle evulation from Javascript
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var location = "Tagenevägen 9"
        
        //Insert registration plate
        bookingView.evaluateJavaScript("document.getElementById('VehicleModel_LicenseNumber').value = '" + selectedCar + "';") { (registrationKey, err) in
             if let err = err{
                 print(err.localizedDescription)
             }
        }
        
        //Insert location
        bookingView.evaluateJavaScript("document.getElementById('addressSearch').value = '" + location + "';") { (locationKey, err) in
             if let err = err{
                 print(err.localizedDescription)
             }
        }
        
        //Clicking search button
        bookingView.evaluateJavaScript("document.getElementsByClassName('btn yellow facility-search-btn')[0].click();") { (buttonPressed, err) in
            if let err = err{
                print(err.localizedDescription)
            }
        }
        
        //Remove
        bookingView.evaluateJavaScript("document.getElementById('nearbyLink').style = 'display:none';") { (response, err) in
            if let err = err{
                print(err.localizedDescription)
            }
        }
        
        //Remove 
        bookingView.evaluateJavaScript("document.getElementById('searchform').style='display:none';") { (response, err) in
            if let err = err{
                print(err.localizedDescription)
            }
        }
        

        //Firstname & Lastname
        bookingView.evaluateJavaScript("document.getElementById('PersonalInformationModel_Name').value = '" + firstname + " " + lastname + "';") { (locationKey, err) in
             if let err = err{
                 print(err.localizedDescription)
             }
        }
        //Email
        bookingView.evaluateJavaScript("document.getElementById('PersonalInformationModel_Email').value = '" + email + "';") { (locationKey, err) in
             if let err = err{
                 print(err.localizedDescription)
             }
        }
        
        //Phone
        bookingView.evaluateJavaScript("document.getElementById('PersonalInformationModel_PhoneNumber').value = '" + phone + "';") { (locationKey, err) in
             if let err = err{
                 print(err.localizedDescription)
             }
        }
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        print("nain")
        return true
    }
}
