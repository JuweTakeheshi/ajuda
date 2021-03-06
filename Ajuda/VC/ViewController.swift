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
    @IBOutlet weak var signInFieldsView: UIView!
    @IBOutlet weak var signInLabel: UILabel!

    var signUpButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.signInButton.alpha = 0
        self.signUpButton?.alpha = 0
        self.signInFieldsView.alpha = 0
        self.signInLabel.alpha = 0
        disableUserInterface()
        customizeUserInterface()
        validateSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func validateSession() {
        let configuration = JUWConfigManager.shared.config
        if let authRequired = configuration?.isAuthRequired {
            if !authRequired {
                pushMapViewController()
            } else {
                let keychain = KeychainSwift()
                let token = keychain.get(kTokenKey)
                if token != nil {
                    pushMapViewController()
                }
                else {
                    enableUserInterface()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.signInLabel.alpha = 1
                        self.signInFieldsView.alpha = 1
                        self.signUpButton?.alpha = 1
                    })
                }
            }
        }
    }

    func pushMapViewController() {
        let mapViewController = storyboard?.instantiateViewController(withIdentifier: "JUWMapViewController") as! JUWMapViewController
        mapViewController.onSignOut = {
            self.enableUserInterface()
        }
        navigationController?.pushViewController(mapViewController, animated: true)
    }

    func customizeUserInterface() {
        customizeNavigationBarColors()
        signInLabel.alpha = 0
        signInFieldsView.alpha = 0
        let logo = UIImage(named:"ajuda_logo_white")
        let imageView = UIImageView()
        imageView.image = logo
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 90, height: 25)
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
        signUpButton?.alpha = 0
        let signUpBarButton = UIBarButtonItem()
        signUpBarButton.customView = signUpButton
        navigationItem.rightBarButtonItem = signUpBarButton
    }

    func disableUserInterface() {
        UIView.animate(withDuration: 0.5) {
            self.signInButton.alpha = 0
            self.signUpButton?.alpha = 0
            self.signInFieldsView.alpha = 0
            self.signInLabel.alpha = 0
        }
        signInButton.isEnabled = false
        usernameTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        signUpButton?.isEnabled = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func enableUserInterface() {
        UIView.animate(withDuration: 0.5) {
            self.signInButton.alpha = 1
            self.signUpButton?.alpha = 1
            self.signInFieldsView.alpha = 1
            self.signInLabel.alpha = 1
        }
        signInButton.isEnabled = true
        usernameTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
        signUpButton?.isEnabled = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    @objc func pushSignUp() {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "JUWSignUpViewController") as! JUWSignUpViewController
        signUpViewController.onSignUp = {
            self.disableUserInterface()
            self.pushMapViewController()
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
                self.pushMapViewController()
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
