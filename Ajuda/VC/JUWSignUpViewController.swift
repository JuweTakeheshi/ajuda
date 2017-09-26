//
//  JUWSignUpViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

public typealias OnSignUp = ()->()

import UIKit

class JUWSignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTypeButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var pickerToolbar: UIToolbar!

    var dismissButton: UIButton?
    var onSignUp: OnSignUp?
    var selectedUserType: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUserInterface()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func customizeUserInterface() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.945, green: 0.525, blue: 0.200, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        dismissButton = UIButton()
        dismissButton?.setImage(UIImage(named: "closeButtonOrange"), for: .normal)
        dismissButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        dismissButton?.addTarget(self, action: #selector(JUWSignUpViewController.dismissSignUp), for: .touchUpInside)
        
        let dismissBarButton = UIBarButtonItem(customView: dismissButton!)
        navigationItem.leftBarButtonItem = dismissBarButton
    }

    func disableUserInterface() {
        dismissButton?.isEnabled = false
        dismissButton?.alpha = 0.5
        userNameTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        signUpButton?.isEnabled = false
    }
    
    func enableUserInterface() {
        dismissButton?.isEnabled = true
        dismissButton?.alpha = 1.0
        userNameTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
        signUpButton?.isEnabled = true
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
        let session = JUWSession.sharedInstance
        if !(userNameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! {
            disableUserInterface()
            session.signUpWithUserName(username: userNameTextField.text!, password: passwordTextField.text!, email: userNameTextField.text!, completion: { (result) in
                self.dismiss(animated: true, completion: {
                    self.enableUserInterface()
                    if self.onSignUp != nil {
                        self.onSignUp!()
                    }
                })
            }, failure: { (error) in
                self.enableUserInterface()
                self.displayErrorAlert(title: "Error en Registro", message: "No pudimos registrarte. Por favor intenta más tarde")
            })
        }
    }

    @IBAction func selectedUserType(_ sender: Any) {
        signUpButton.alpha = 1
        signUpButton.isEnabled = true
        pickerToolbar.isHidden = true
        pickerView.isHidden = true

        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        let session = JUWSession.sharedInstance
        selectedUserType = session.userTypes[selectedIndex].rawValue
        let formattedString = String.localizedStringWithFormat("Soy %@", selectedUserType!)
        userTypeButton.setTitle(formattedString, for: .normal)
    }

    @objc func dismissSignUp() {
        self.navigationController?.dismiss(animated: true, completion: nil)
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

    // MARK: - UITextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
}
