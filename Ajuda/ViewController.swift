//
//  ViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInTextField: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }

    @IBAction func signIn(_ sender: Any) {
    }

}

