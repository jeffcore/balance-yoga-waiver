//
//  ViewController.swift
//  BalanceYogaWaiver
//
//  Created by rixcore on 9/17/18.
//  Copyright © 2018 rixcore. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
   
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var birthPopupView: UIView!
    @IBOutlet weak var birthDateDoneButton: UIButton!
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var lastNameTextBox: UITextField!
    @IBOutlet weak var addressTextBox: UITextField!
    @IBOutlet weak var cityTextBox: UITextField!
    @IBOutlet weak var stateTextBox: UITextField!
    @IBOutlet weak var zipTextBox: UITextField!
    @IBOutlet weak var phoneTextBox: UITextField!
    @IBOutlet weak var emergencyTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var birthDateTextBox: UITextField!
    @IBOutlet weak var hearUsTextBox: UITextField!
    @IBOutlet weak var injuriesTextBox: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var statePopupView: UIView!
    @IBOutlet weak var stateDoneButton: UIButton!
    @IBOutlet weak var hearUsPickerView: UIView!
    @IBOutlet weak var hearUsPicker: UIPickerView!
    @IBOutlet weak var hearUsDoneButton: UIButton!
    @IBOutlet weak var resetFormButton: UIButton!
    
    let componentCount: Int = 1
    var state: [String] = [String]()
    var hearUs: [String] = [String]()
    var stateSelected: Int = 46
    var dateBirthFinal: Date = Date()
    var customer: Customer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.delegate = self
        statePicker.dataSource = self
        hearUsPicker.delegate = self
        hearUsPicker.dataSource = self
        
        hearUs = [ "Choose One:",
                   "Friend",
                   "Family",
                   "Google",
                   "Facebook",
                   "Yelp",
                   "Class Pass",
                   "Drove By",
                   "Teacher",
                   "None"]
        
        state = [ "AK - Alaska",
                  "AL - Alabama",
                  "AR - Arkansas",
                  "AS - American Samoa",
                  "AZ - Arizona",
                  "CA - California",
                  "CO - Colorado",
                  "CT - Connecticut",
                  "DC - District of Columbia",
                  "DE - Delaware",
                  "FL - Florida",
                  "GA - Georgia",
                  "GU - Guam",
                  "HI - Hawaii",
                  "IA - Iowa",
                  "ID - Idaho",
                  "IL - Illinois",
                  "IN - Indiana",
                  "KS - Kansas",
                  "KY - Kentucky",
                  "LA - Louisiana",
                  "MA - Massachusetts",
                  "MD - Maryland",
                  "ME - Maine",
                  "MI - Michigan",
                  "MN - Minnesota",
                  "MO - Missouri",
                  "MS - Mississippi",
                  "MT - Montana",
                  "NC - North Carolina",
                  "ND - North Dakota",
                  "NE - Nebraska",
                  "NH - New Hampshire",
                  "NJ - New Jersey",
                  "NM - New Mexico",
                  "NV - Nevada",
                  "NY - New York",
                  "OH - Ohio",
                  "OK - Oklahoma",
                  "OR - Oregon",
                  "PA - Pennsylvania",
                  "PR - Puerto Rico",
                  "RI - Rhode Island",
                  "SC - South Carolina",
                  "SD - South Dakota",
                  "TN - Tennessee",
                  "TX - Texas",
                  "UT - Utah",
                  "VA - Virginia",
                  "VI - Virgin Islands",
                  "VT - Vermont",
                  "WA - Washington",
                  "WI - Wisconsin",
                  "WV - West Virginia",
                  "WY - Wyoming"]
        
        birthPopupView.isHidden = true
        statePopupView.isHidden = true
        hearUsPickerView.isHidden = true
        let currentDateTime = Date()
        birthDatePicker.maximumDate = currentDateTime
        
        nameTextBox.borderStyle = UITextBorderStyle.roundedRect
        lastNameTextBox.borderStyle = UITextBorderStyle.roundedRect
        addressTextBox.borderStyle = UITextBorderStyle.roundedRect
        cityTextBox.borderStyle = UITextBorderStyle.roundedRect
        stateTextBox.borderStyle = UITextBorderStyle.roundedRect
        zipTextBox.borderStyle = UITextBorderStyle.roundedRect
        phoneTextBox.borderStyle = UITextBorderStyle.roundedRect
        emergencyTextBox.borderStyle = UITextBorderStyle.roundedRect
        emailTextBox.borderStyle = UITextBorderStyle.roundedRect
        birthDateTextBox.borderStyle = UITextBorderStyle.roundedRect
        hearUsTextBox.borderStyle = UITextBorderStyle.roundedRect
        injuriesTextBox.borderStyle = UITextBorderStyle.roundedRect
        stateDoneButton.layer.cornerRadius = 5
        continueButton.layer.cornerRadius = 5
        birthDateDoneButton.layer.cornerRadius = 5
        hearUsDoneButton.layer.cornerRadius = 5
        resetFormButton.layer.cornerRadius = 5
        
        statePicker.tag = 0
        hearUsPicker.tag = 1
        
        nameTextBox.delegate = self
        lastNameTextBox.delegate = self
        addressTextBox.delegate = self
        cityTextBox.delegate = self
        stateTextBox.delegate = self
        zipTextBox.delegate = self
        phoneTextBox.delegate = self
        emergencyTextBox.delegate = self
        emailTextBox.delegate = self
        birthDateTextBox.delegate = self
        hearUsTextBox.delegate = self
        injuriesTextBox.delegate = self
        
        nameTextBox.becomeFirstResponder()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        mainView.addGestureRecognizer(gesture)
        
        if customer != nil {
            setFormDataFromCustomer()
        }
        
        // setTestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return hit")
        if textField == nameTextBox {
            textField.resignFirstResponder()
            lastNameTextBox.becomeFirstResponder()
        } else if textField == lastNameTextBox {
            textField.resignFirstResponder()
            addressTextBox.becomeFirstResponder()
        } else if textField == addressTextBox {
            textField.resignFirstResponder()
            cityTextBox.becomeFirstResponder()
        } else if textField == cityTextBox {
            textField.resignFirstResponder()
            loadStatePicker()
        } else if textField == zipTextBox {
            textField.resignFirstResponder()
            phoneTextBox.becomeFirstResponder()
        } else if textField == phoneTextBox {
            textField.resignFirstResponder()
            emergencyTextBox.becomeFirstResponder()
        } else if textField == emergencyTextBox {
            textField.resignFirstResponder()
            emailTextBox.becomeFirstResponder()
        } else if textField == emailTextBox {
            textField.resignFirstResponder()
            loadBirthDatePicker()
        }
        return false
    }
    
    @IBAction func touchTextField(_ sender: UITextField) {
        birthPopupView.isHidden = true
        statePopupView.isHidden = true
        hearUsPickerView.isHidden = true
        stateTextBox.isUserInteractionEnabled = true
        birthDateTextBox.isUserInteractionEnabled = true
        hearUsTextBox.isUserInteractionEnabled = true
        continueButton.isHidden = false
    }
    
    @IBAction func clickContinueButton(_ sender: UIButton) {
        var isError = false
        var birthDateFinalString: String = ""
        
        if nameTextBox.text?.isEmpty ?? true {
            isError = true
            nameLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0.2745098039, blue: 0.3058823529, alpha: 1)
        } else {
            nameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
       
        if lastNameTextBox.text?.isEmpty ?? true {
            isError = true
            lastNameLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0.2745098039, blue: 0.3058823529, alpha: 1)
        } else {
            lastNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if addressTextBox.text?.isEmpty ?? true {
            isError = true
            addressLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0.2745098039, blue: 0.3058823529, alpha: 1)
        } else {
            addressLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if cityTextBox.text?.isEmpty ?? true {
            isError = true
            cityLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0.2745098039, blue: 0.3058823529, alpha: 1)
        } else {
            cityLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if zipTextBox.text?.isEmpty ?? true {
            isError = true
            zipLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0.2745098039, blue: 0.3058823529, alpha: 1)
        } else {
            zipLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if phoneTextBox.text?.isEmpty ?? true {
            isError = true
            phoneLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0.2745098039, blue: 0.3058823529, alpha: 1)
        } else {
            phoneLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if emailTextBox.text?.isEmpty ?? true {
            isError = true
            emailLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0.2745098039, blue: 0.3058823529, alpha: 1)
        } else {
            emailLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if birthDateTextBox.text?.isEmpty ?? true {
            birthDateFinalString = ""
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            birthDateFinalString = dateFormatter.string(from: dateBirthFinal)
        }
        
        var injuryText: String = ""
        if injuriesTextBox.text?.lowercased() != "none" {
            injuryText = injuriesTextBox.text ?? ""
        }
        
        if !isError {
            customer = Customer(firstName: nameTextBox.text!, lastName: lastNameTextBox.text!, address: addressTextBox.text ?? "", city: cityTextBox.text ?? "", state: stateTextBox.text ?? "", zip: zipTextBox.text ?? "", phone: phoneTextBox.text ?? "", emergencyPhone: emergencyTextBox.text ?? "", email: emailTextBox.text!, birthDate: birthDateFinalString, hearUs: hearUsTextBox.text ?? "", injuries: injuryText)
            print(customer!.printCustomer())
            
            performSegue(withIdentifier: "WaiverSegue", sender: self)
        } else {
            alert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is WavierViewController
        {
            let vc = segue.destination as? WavierViewController
            
            vc?.customer = customer!
        }
    }
    
    @IBAction func clickStateTextBox(_ sender: UITextField) {
        loadStatePicker()
    }
    
    func loadStatePicker() {
        stateTextBox.isUserInteractionEnabled = false
        statePopupView.isHidden = false
        continueButton.isHidden = true
        birthPopupView.isHidden = true
        birthDateTextBox.isUserInteractionEnabled = true
        statePicker.selectRow(stateSelected, inComponent: 0, animated: true)
    }
    
    @IBAction func clickBirthTextBox(_ sender: UITextField) {
        loadBirthDatePicker()
    }
    
    func loadBirthDatePicker() {
        birthDateTextBox.isUserInteractionEnabled = false
        birthPopupView.isHidden = false
        birthDatePicker.isHidden = false
        continueButton.isHidden = true
        stateTextBox.isUserInteractionEnabled = true
        statePopupView.isHidden = true
        hearUsPickerView.isHidden = true
        emailTextBox.resignFirstResponder()
        emergencyTextBox.resignFirstResponder()
    }
    
    @IBAction func editingStartedHearUsTextBox(_ sender: UITextField) {
        loadHearUsPicker()
    }
    
    func loadHearUsPicker() {
        hearUsTextBox.isUserInteractionEnabled = false
        hearUsPickerView.isHidden = false
        birthPopupView.isHidden = true
        continueButton.isHidden = true
        stateTextBox.isUserInteractionEnabled = true
        statePopupView.isHidden = true
        birthDateTextBox.resignFirstResponder()
        emailTextBox.resignFirstResponder()
    }
    
    @IBAction func birthDatePickerChanged(_ sender: UIDatePicker) {
        print("print \(sender.date)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        dateBirthFinal = sender.date
        let somedateString = dateFormatter.string(from: sender.date)
        
        birthDateTextBox.text = somedateString // "somedateString" is your string date
    }
    
    @IBAction func clickStateDoneButton(_ sender: Any) {
        statePopupView.isHidden = true
        continueButton.isHidden = false
        stateTextBox.isUserInteractionEnabled = true
        zipTextBox.becomeFirstResponder()
    }
    
    @IBAction func resetFormButton(_ sender: Any) {
        alertResetForm()
    }
    
    func resetForm() {
        nameTextBox.text = ""
        lastNameTextBox.text = ""
        addressTextBox.text = ""
        cityTextBox.text = ""
        zipTextBox.text = ""
        phoneTextBox.text = ""
        emergencyTextBox.text = ""
        hearUsTextBox.text = ""
        injuriesTextBox.text = ""
        emailTextBox.text = ""
        birthDateTextBox.text = ""
        stateTextBox.text = "TX"
        nameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addressLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cityLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        zipLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phoneLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @IBAction func clickBirthDateDoneButton(_ sender: Any) {
        birthPopupView.isHidden = true
        birthDatePicker.isHidden = true
        continueButton.isHidden = false
        birthDateTextBox.isUserInteractionEnabled = true
        // loadHearUsPicker()
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        birthPopupView.isHidden = true
        birthDatePicker.isHidden = true
        continueButton.isHidden = false
        stateTextBox.isUserInteractionEnabled = true
        birthDateTextBox.isUserInteractionEnabled = true
        hearUsTextBox.isUserInteractionEnabled = true
        statePopupView.isHidden = true
        hearUsPickerView.isHidden = true
    }
    @IBAction func clickHearUsDoneButton(_ sender: Any) {
        hearUsPickerView.isHidden = true
        continueButton.isHidden = false
        hearUsTextBox.isUserInteractionEnabled = true
        injuriesTextBox.becomeFirstResponder()
    }
    
    func setTestData() {
        nameTextBox.text = "Tester"
        lastNameTextBox.text = "Ted"
        addressTextBox.text = "123 Test RD"
        cityTextBox.text = "City"
        zipTextBox.text = "434343"
        phoneTextBox.text = "434-343-4444"
        emergencyTextBox.text = "232-324-2222"
        hearUsTextBox.text = "google"
        injuriesTextBox.text = "head"
        emailTextBox.text = "test@tester2222.com"
        birthDateTextBox.text = "Nov 21, 1975"
    }
    
    func setFormDataFromCustomer() {
        nameTextBox.text = customer!.firstName
        lastNameTextBox.text = customer!.lastName
        addressTextBox.text = customer!.address
        cityTextBox.text = customer!.city
        stateTextBox.text = customer!.state
        zipTextBox.text = customer!.zip
        phoneTextBox.text = customer!.phone
        emergencyTextBox.text = customer!.emergencyPhone ?? ""
        hearUsTextBox.text = customer!.hearUs ?? ""
        injuriesTextBox.text = customer!.injuries ?? ""
        emailTextBox.text = customer!.email
        birthDateTextBox.text = customer!.birthDate ?? ""
    }
    
    func alert() {
        let alert = UIAlertController(title: "Form Error", message: "Please complete required fields in red", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        
        self.present(alert, animated: true)
    }
    
    func alertResetForm() {
        let alert = UIAlertController(title: "Form Reset", message: "Do you want to clear all data?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.resetForm()
        }))
               
        self.present(alert, animated: true)
    }
    
    
    // state picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return componentCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            //pickerView1
            return state.count
        } else {
            return hearUs.count
        }
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            //pickerView1
            return state[row]
        } else {
            return hearUs[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        if (pickerView.tag == 0) {
            //pickerView1
            stateSelected = row
            stateTextBox.text = String(state[row].prefix(2))
        } else {
            if (row == 0) {
                hearUsTextBox.text = ""
            } else {
                hearUsTextBox.text = String(hearUs[row])
            }
           
        }
    }
}

