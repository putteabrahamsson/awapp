//
//  GiveDiscountViewController.swift
//  awapp
//
//  Created by Putte on 2019-12-09.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class GiveDiscountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //Discount code
    @IBOutlet weak var discountCode: UITextField!
    
    //Button
    @IBOutlet weak var createDiscountButton: UIButton!
    
    //Pickerview
    @IBOutlet weak var pickerView: UIPickerView!
    var selectedItem: String!
    @IBOutlet weak var other: UITextField!
    
    //Amount of percent
    @IBOutlet weak var percentTextfield: UITextField!
    @IBOutlet weak var slider: UISlider!
    
    //Expiring date
    @IBOutlet weak var datePicker: UIDatePicker!
    var currentDate: String!
    
    //Firebase
    let db = Firestore.firestore()
    
    //Pickerview data
    var pickerData = ["Butik", "Service", "Reparation", "Däckbyte", "Däckhotell", "Övrigt"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets selectedItem to first value in array
        selectedItem = pickerData.first
        
        //Sets datepicker to current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        currentDate = dateFormatter.string(from: datePicker.date)
        
        //Delegating
        discountCode.delegate = self
        percentTextfield.delegate = self
        other.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    //Setting corner radius of button
    override func viewDidAppear(_ animated: Bool) {
        createDiscountButton.layer.cornerRadius = 10
    }
    
    //If slider (percentage) is changed.
    @IBAction func percentChanged(_ sender: Any) {
        let sliderToInt = Int(slider.value)
        
        percentTextfield.text = String(sliderToInt) + "%"
    }
    
    //If date is changed
    @IBAction func dateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        currentDate = dateFormatter.string(from: datePicker.date)
    }
    
    
    //Pickerview properties
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedItem = pickerData[row]
        
        if(selectedItem == "Övrigt"){
            other.isHidden = false
        }
        else{
            other.isHidden = true
        }
    }
    
    //Give discount button is tapped
    @IBAction func giveDiscountButtonTapped(_ sender: Any) {
        if(!discountCode.text!.isEmpty){
            if selectedItem == "Övrigt"{
                if !other.text!.isEmpty{
                    selectedItem = other.text
                    saveToFirestore()
                }
            }
            else{
                saveToFirestore()
            }
        }
    }
    
    //Save the new discount code
    func saveToFirestore(){
        db.collection("discountCode").addDocument(data:
            [
                "discountID" : discountCode.text!,
                "category" : selectedItem!,
                "percent" : percentTextfield.text!,
                "expiring" : currentDate!
        ]) { (err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                let alert = UIAlertController.init(title: "Lyckades!", message: "En ny rabatt har skapats med koden '" + self.discountCode.text! + "'", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Stäng", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
    }
    
    //Keyboard settings
    @IBAction func tapToDismissKeyboard(_ sender: Any) {
        discountCode.resignFirstResponder()
        percentTextfield.resignFirstResponder()
        other.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
