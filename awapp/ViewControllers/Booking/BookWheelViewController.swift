//
//  BookWheelViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import WebKit

class BookWheelViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var bookingView: WKWebView!
    @IBOutlet weak var header: UINavigationItem!
    
    var firstName: String!
    var lastName: String!
    var phone: String!
    var email: String!
    
    var selectedCar: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateCode()
        
        bookingView.navigationDelegate = self
        
        //Open webview
        openWebView()
        
        retrieveData()
    }
    
    func translateCode(){
        header.title = NSLocalizedString("wheel_header", comment: "")
    }

    func retrieveData(){
        let defaults = UserDefaults.standard
        
        firstName = defaults.string(forKey: "firstname") ?? ""
        lastName = defaults.string(forKey: "lastname") ?? ""
        email = defaults.string(forKey: "epost") ?? ""
        phone = defaults.string(forKey: "phone") ?? ""
        selectedCar = defaults.string(forKey: "currentCar") ?? ""

    }
    
    func openWebView(){
        if let url = NSURL(string: "https://www.timecenter.se/mekonomen/"){
            let request = NSURLRequest(url: url as URL)
            
            bookingView.load(request as URLRequest)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

 
        //Remove header
        bookingView.evaluateJavaScript("document.getElementById('tc-header').style='display:none';") { (response, err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                print(response)
            }
        }
        
          //Insert registration number
        bookingView.evaluateJavaScript("document.getElementById('custom1').value = '" + selectedCar + "';") { (key, err) in
               if let err = err{
                   print(err.localizedDescription)
               }
           }
           
           //Insert firstname
          bookingView.evaluateJavaScript("document.getElementById('fnamn').value = '" + firstName + "';") { (key, err) in
               if let err = err{
                   print(err.localizedDescription)
               }
           }
           
           //Insert lastname
          bookingView.evaluateJavaScript("document.getElementById('enamn').value = '" + lastName + "';") { (key, err) in
               if let err = err{
                   print(err.localizedDescription)
               }
           }
        
         //Insert phone
        bookingView.evaluateJavaScript("document.getElementById('a2').value = '" + phone + "';") { (key, err) in
             if let err = err{
                 print(err.localizedDescription)
             }
         }
        
         //Insert email
        bookingView.evaluateJavaScript("document.getElementById('a1').value = '" + email + "';") { (key, err) in
             if let err = err{
                 print(err.localizedDescription)
             }
         }
    }

}
