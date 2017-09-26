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
        validateSession()
        customizeUserInterface()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func validateSession() {
        let keychain = KeychainSwift()
        let token = keychain.get(kTokenKey)
        if token != nil {
            let mapViewController = storyboard?.instantiateViewController(withIdentifier: "JUWMapViewController") as! JUWMapViewController
            navigationController?.pushViewController(mapViewController, animated: false)
        }
    }

    func customizeUserInterface() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.945, green: 0.525, blue: 0.200, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let signUpButton = UIButton()
        signUpButton.setTitle("Registro", for: .normal)
        signUpButton.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Bold", size: 16.0)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.frame = CGRect(x: 0, y: 0, width: 60, height: 45)
        signUpButton.addTarget(self, action: #selector(ViewController.pushSignUp), for: .touchUpInside)
        let signUpBarButton = UIBarButtonItem()
        signUpBarButton.customView = signUpButton
        self.navigationItem.rightBarButtonItem = signUpBarButton
    }

    @objc func pushSignUp() {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "JUWSignUpViewController") as! JUWSignUpViewController
        signUpViewController.onSignUp = {
            let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "JUWMapViewController") as! JUWMapViewController
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
        let navigationController = UINavigationController(rootViewController: signUpViewController)
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func signIn(_ sender: Any) {
        if !(usernameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! {
            let session = JUWSession.sharedInstance
            session.signInWithUserName(username: usernameTextField.text!, password: passwordTextField.text!, completion: {
                let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "JUWMapViewController") as! JUWMapViewController
                self.navigationController?.pushViewController(mapViewController, animated: true)
            }, failure: { (error) in
                self.displayErrorAlert(title: "Error al ingresar",
                                       message: "No pudimos verificar tus datos. Confirma que los escribiste correctamente")
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

