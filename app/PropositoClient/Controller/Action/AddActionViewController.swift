//
//  AddPrayViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 02/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit
import UserNotifications

class AddActionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //Button of close
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Description
    @IBOutlet weak var descriptionPray: UITextField!
    @IBOutlet weak var alertDescription: UILabel!
    func validateDescription() -> Bool { return descriptionPray.text != "" }
    
    //Picker of prayers
    var prayers = [Prayer]()
    var pickerData: [String] = [String]()
    var pickerDataId: [Int] = [Int]()
    var pickerSelected: String = ""
    var pickerSelectedRow: Int = 0
    
    @IBOutlet weak var pickerPray: UIPickerView!
    @IBOutlet weak var alertPicker: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data of Prayers
        loadData()
        setForRemoveAlerts()
        
        //Hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelected = pickerData[row]
        pickerSelectedRow = row
    }
    
    //Date picker
    var dateInPicker = Date()
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alertDate: UILabel!
    
    func validateDate() -> Bool { return datePicker.date >= Date() }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        alertDate.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateInPicker = sender.date
    }
    
    //Button of Add Pray
    @IBAction func addAction(_ sender: UIButton) {
//        if prayers.count > 0 {
//            if validateDescription() {
//                if validateDate() {
//                    //Body
//                    let title = descriptionPray.text ?? ""
//                    let pray = pickerSelected
//                    let date = self.dateInPicker
//                    let prayID = self.prayers[pickerSelectedRow].id
//                    
//                    //Act
//                    let act = Action(id: Int.gererateId(), prayID: prayID, title: title, pray: pray, completed: false, date: date)
//                    
//                    //Create in CoreDate
//                    ActionHandler.create(act: act) { (res) in
//                        switch (res) {
//                        case .success(let act):
//                            self.addActIntoPray(act)
//                            self.sendNotification(act)
//                            self.goToMain()
//                        case .error(let description):
//                            print(description)
//                        }
//                    }
//                } else { alertDate.isHidden = false }
//            } else { alertDescription.isHidden = false }
//        } else { alertPicker.isHidden = false }
    }
    
    //Switch Notification
    var userWantNotification = false
    @IBAction func wantNotification(_ sender: UISwitch) {
        if sender.isOn {
            requestAuthNotification()
            userWantNotification = true
        } else {
            userWantNotification = false
        }
    }
    
    
    func loadData() {
        //Load data of the Prayers
//        PrayerHandler.loadPrayWith { (res) in
//            switch (res) {
//            case .success(let prayers):
//                prayers.forEach({ (pray) in
//                    if !pray.answered {
//                        self.prayers.append(pray)
////                        self.pickerData.append(pray.title)
//                        self.pickerDataId.append(pray.id)
//                    }
//                })
//
//            case .error(let description):
//                print(description)
//            }
//        }
//
//        if pickerData.count != 0 {
//            pickerSelected = pickerData[0]
//        } else {
//            pickerData.append("Nenhuma oração")
//        }
//        //Set a Color UIPickerView Date
//        self.datePicker.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKeyPath: "textColor")
    }
    
    //Validade number of characters in the textfild
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 50
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 50
    }
    
    //Take editing in textfilds
    func setForRemoveAlerts() {
        descriptionPray.addTarget(self, action: #selector(descriptionDidChange(_:)), for: .editingChanged)
    }
    @objc func descriptionDidChange(_ textField: UITextField) {
        alertDescription.isHidden = true
    }
    
    //Hide Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //Create Notification
    func sendNotification(_ act:Action) {
        if userWantNotification {
            //call app
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            //create body
            let title = act.name
            let subtitle = "" //REMAKE
            let mensage = "A fé sem obras é morta!"
            let identifier = "identifier\(title)"
            var time = act.date - Date()
            if(time < 0){
                time = 10
            }
            //create
            appDelegate?.enviarNotificacao(title, subtitle, mensage, identifier, time)
        }
    }
    
    private func goToMain(){
        guard let main = self.presentingViewController?.presentingViewController?.children[0] as? MainViewController else { return }
        main.loadDataAct()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func requestAuthNotification(){
        let notificationCenter = UNUserNotificationCenter.current()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        notificationCenter.delegate = appDelegate
        let opcoes: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: opcoes) {
            (foiPermitido, error) in
            if !foiPermitido {
                print("O usúario não permitiu, não podemos enviar notificacão")
            }
        }
    }
    
    private func addActIntoPray(_ act:Action){
        var prayToUpdate = self.prayers[pickerSelectedRow]
        prayToUpdate.actions.append(act.id)
        
        PrayerHandler.update(pray: prayToUpdate) { (res) in
            switch (res) {
            case .success(let pray):
                print(pray)
            case .error(let description):
                print(description)
            }
        }
    }
    @objc
    func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -85
    }
    
    @objc
    func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}