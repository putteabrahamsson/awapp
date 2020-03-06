//
//  DiscountViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class DiscountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDiscountText: UILabel!
    @IBOutlet weak var header: UINavigationItem!
    
    var list: [listTxt] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateCode()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        list = getDataFromFirestore()
    }
    
    //Translate code
    func translateCode(){
        header.title = NSLocalizedString("discount_header", comment: "")
        noDiscountText.text = NSLocalizedString("discount_none", comment: "")
    }
    
    //viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        if tableView.visibleCells.isEmpty{
            self.noDiscountText.isHidden = false
            view.bringSubviewToFront(noDiscountText)
        }
        else{
            self.noDiscountText.isHidden = true
        }
    }
    
    //Retrieving data from Firestore
    func getDataFromFirestore() -> [listTxt]{
        
        var tempTxt: [listTxt] = []
        
        let authentication = Auth.auth().currentUser?.uid
        db.collection("users").document(authentication!).collection("discount").order(by: "expiring").getDocuments { (query, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                for documents in query!.documents{
                    self.list.removeAll()
                    let data = documents.data()
                    
                    let category = data["category"] as? String
                    let percent = data["percent"] as? String
                    let expiring = data["expiring"] as? String
                    let documentId = documents.documentID
                    
                    //Get current date and time
                    let currentDateTime = Date()
                    
                    //Convert string to date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let date = dateFormatter.date(from: expiring!)
                    
                    //Check if date has expired
                    if date! <= currentDateTime{
                        self.deleteDiscountIfExpired(documentID: documentId)
                    }else{
                        print("not expried")
                    }
                    
                    let txt = listTxt(category: category!, percent: percent!, expiring: expiring!, documentId: documentId)
                    
                    tempTxt.append(txt)
                }
                self.list = tempTxt
                self.tableView.reloadData()
            }
        }
        return list
    }
    
    //Tableview properties
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listPath = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "discountCell", for: indexPath) as! DiscountTableViewCell
        
        cell.setCell(list: listPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let storyboard = storyboard{
            
            //Deselecting the row
            tableView.deselectRow(at: indexPath, animated: false)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "UseDiscountViewController") as! UseDiscountViewController
            
            let cell = tableView.cellForRow(at: indexPath) as! DiscountTableViewCell
            
            vc.percent = cell.percent.text
            vc.category = cell.category.text
            vc.expiring = cell.expiring.text
            vc.docID = cell.documentId.text
            
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    //Delete document if expired
    func deleteDiscountIfExpired(documentID: String!){
        let authentication = Auth.auth().currentUser?.uid
        self.db.collection("users").document(authentication!).collection("discount").document(documentID).delete { (err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                print("Successfully deleted discount code")
                self.list = self.getDataFromFirestore()
            }
        }
    }

}
