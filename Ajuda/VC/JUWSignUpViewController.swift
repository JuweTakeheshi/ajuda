//
//  JUWSignUpViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class JUWSignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTypeButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var pickerToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showUserTypeSelection(_ sender: Any) {
        if userNameTextField.isFirstResponder {
            userNameTextField.resignFirstResponder()
        }
        else {
            passwordTextField.resignFirstResponder()
        }

        pickerToolbar.isHidden = false
        pickerView.isHidden = false
    }

    @IBAction func signUp(_ sender: Any) {
        
    }

    @IBAction func selectedUserType(_ sender: Any) {
        signUpButton.alpha = 1
        signUpButton.isEnabled = true
        pickerToolbar.isHidden = true
        pickerView.isHidden = true

        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        let session = JUWSession.sharedInstance
        let formattedString = String.localizedStringWithFormat("Soy %@", session.userTypes[selectedIndex].rawValue)
        userTypeButton.setTitle(formattedString, for: .normal)
    }
    // MARK: - UIPickerView

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        let session = JUWSession.sharedInstance
        return session.userTypes.count
    }

    func pickerView(_ pickerView: UIPickerView,
                             titleForRow row: Int,
                             forComponent component: Int) -> String? {
        let session = JUWSession.sharedInstance
        return session.userTypes[row].rawValue
    }
}
