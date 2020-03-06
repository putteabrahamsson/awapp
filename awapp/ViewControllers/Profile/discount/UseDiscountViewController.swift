//
//  UseDiscountViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class UseDiscountViewController: UIViewController {
    
    var percent: String!
    var category: String!
    var expiring: String!
    var docID: String!

    @IBOutlet weak var qrView: UIImageView!
    @IBOutlet weak var typeOfCategory: UILabel!
    @IBOutlet weak var typeOfPercentage: UILabel!
    @IBOutlet weak var typeOfExpiring: UILabel!
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var showQrText: UILabel!
    @IBOutlet weak var discountInfo: UILabel!
    @IBOutlet weak var categoryTxt: UILabel!
    @IBOutlet weak var percentTxt: UILabel!
    @IBOutlet weak var expiresTxt: UILabel!
    @IBOutlet weak var validAt: UILabel!
    
    //Initialize Firestore
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translateCode()
        
        typeOfCategory.text = category
        typeOfPercentage.text = percent
        typeOfExpiring.text = expiring
        
        generateQR()
    }
    
    //Translate code
    func translateCode(){
        header.title = NSLocalizedString("use_discount_header", comment: "")
        showQrText.text = NSLocalizedString("use_discount_qr_text", comment: "")
        discountInfo.text = NSLocalizedString("use_discount_info", comment: "")
        categoryTxt.text = NSLocalizedString("use_discount_category", comment: "")
        percentTxt.text = NSLocalizedString("use_discount_percent", comment: "")
        expiresTxt.text = NSLocalizedString("use_discount_expires", comment: "")
        validAt.text = NSLocalizedString("use_discount_valid_at", comment: "")
    }
    
    //Generating a new QR depending on document ID
    func generateQR(){
        let authId = Auth.auth().currentUser?.uid
        
        if let myString = docID{
            let data = "\(String(describing: docID!)),\(authId!)".data(using: .ascii, allowLossyConversion: false)

            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            let ciImage = filter?.outputImage
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = (ciImage?.transformed(by: transform))
            
            let image = UIImage(ciImage: transformImage!)
            
            qrView.image = image
        }
    }
}
