//
//  ScanQrViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-07.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ScanQrViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let db = Firestore.firestore()
    
    var video = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Session
        let session = AVCaptureSession()
        
        //Define capture device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print("ERROR!")
        }
        
        //Creating design for QR code
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    //When the phone has scanned a QR code
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.qr{
                    
                    let arr = object.stringValue!.components(separatedBy:",")
                    let docId = arr[0]
                    let authId = arr[1]
                    
                    //Show alert to ask admin to use QR code
                    let alert = UIAlertController.init(title: "QR Code", message: "Vill du använda denna QR koden?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction.init(title: "Ny", style: .cancel, handler: nil))
                    
                    alert.addAction(UIAlertAction.init(title: "Använd", style: .default, handler: { (nil) in
                        
                        self.removeDiscountFromFirestore(documentId: docId, authentication: authId)
                    }))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    //Remove discount from Firestore if scanned
    func removeDiscountFromFirestore(documentId: String!, authentication: String!){
    
        //Checking if QR code exists / already used
        db.collection("users").document(authentication!).collection("discount").document(documentId!).getDocument { (document, err) in
            if !document!.exists{
                let alert = UIAlertController.init(title: "Ops!", message: "QR koden existerar inte!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            else{
               //Removing the document if QR code exists
                self.db.collection("users").document(authentication!).collection("discount").document(documentId!).delete { (err) in
                    if let err = err{
                        print(err.localizedDescription)
                    }
                    else{
                        print("Deleted document ", documentId!, " ", authentication!)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    

}
