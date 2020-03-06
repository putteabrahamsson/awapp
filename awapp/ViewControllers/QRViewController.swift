//
//  QRViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-07.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateQR()
    }
    
    func generateQR(){
        let myString = "google.com"
        
        let data = myString.data(using: .ascii, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        let ciImage = filter?.outputImage
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = (ciImage?.transformed(by: transform))
        
        let image = UIImage(ciImage: transformImage!)
        
        imageView.image = image
    }

}
