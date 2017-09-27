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
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    var signUpButton: UIButton?

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
        customizeNavigationBarColors()
        let logo = UIImage(named:"ajuda_logo_white")
        let imageView = UIImageView()
        imageView.image = logo
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 40)
        navigationItem.titleView = imageView

        let emptyView = UIImageView()
        emptyView.frame = CGRect(x: 0, y: 0, width: 70, height: 40)
        let emptyLeftView = UIBarButtonItem()
        emptyLeftView.customView = emptyView
        navigationItem.leftBarButtonItem = emptyLeftView

        signUpButton = UIButton()
        signUpButton?.setTitle("Registro", for: .normal)
        signUpButton?.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Bold", size: 15.0)
        signUpButton?.setTitleColor(UIColor.white, for: .normal)
        signUpButton?.frame = CGRect(x: 0, y: 0, width: 70, height: 45)
        signUpButton?.addTarget(self, action: #selector(ViewController.pushSignUp), for: .touchUpInside)
        let signUpBarButton = UIBarButtonItem()
        signUpBarButton.customView = signUpButton
        navigationItem.rightBarButtonItem = signUpBarButton
    }

    func disableUserInterface() {
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        usernameTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        signUpButton?.isEnabled = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func enableUserInterface() {
        signInButton.isEnabled = true
        signInButton.alpha = 1.0
        usernameTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
        signUpButton?.isEnabled = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
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
            disableUserInterface()
            let session = JUWSession.sharedInstance
            session.signInWithUserName(username: usernameTextField.text!, password: passwordTextField.text!, completion: {
                self.enableUserInterface()
                let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "JUWMapViewController") as! JUWMapViewController
                self.navigationController?.pushViewController(mapViewController, animated: true)
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
            }, failure: { (error) in
                self.enableUserInterface()
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
