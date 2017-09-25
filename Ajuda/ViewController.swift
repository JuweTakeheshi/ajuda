//
//  ViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInTextField: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        provisionalSkipSingIn()
        validateSession()
        customizeUserInterface()
    }
    
//    func provisionalSkipSingIn(){
//        let mapViewController = storyboard?.instantiateViewController(withIdentifier: "JUWMapViewController") as! JUWMapViewController
//        let provisionalNavC = UINavigationController(rootViewController: mapViewController)
//        self.present(provisionalNavC, animated: false, completion:nil)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func validateSession() {
        let token = JUWKeychainService.loadToken()
        if token != nil {
            let mapViewController = storyboard?.instantiateViewController(withIdentifier: "JUWMapViewController") as! JUWMapViewController
            navigationController?.pushViewController(mapViewController, animated: false)
        }
    }

    func customizeUserInterface() {
        let signUpButton = UIButton()
        signUpButton.setTitle("Registro", for: .normal)
        signUpButton.frame = CGRect(x: 0, y: 0, width: 80, height: 45)
        signUpButton.setTitleColor(UIColor.black, for: .normal)
        signUpButton.addTarget(self, action: #selector(ViewController.pushSignUp), for: .touchUpInside)
        let signUpBarButton = UIBarButtonItem()
        signUpBarButton.customView = signUpButton
        self.navigationItem.rightBarButtonItem = signUpBarButton
    }

    @objc func pushSignUp() {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "JUWSignUpViewController") as! JUWSignUpViewController
        let navigationController = UINavigationController(rootViewController: signUpViewController)
        present(navigationController, animated: true) {
            
        }
    }

    @IBAction func signIn(_ sender: Any) {
        if !(usernameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! {
            let session = JUWSession.sharedInstance
            session.signInWithUserName(username: usernameTextField.text!, password: passwordTextField.text!, completion: {
                let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "JUWMapViewController") as! JUWMapViewController
                self.navigationController?.pushViewController(mapViewController, animated: true)
            }, failure: { (error) in
                
            })
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            passwordTextField.resignFirstResponder()
        }

        return true
    }
}

