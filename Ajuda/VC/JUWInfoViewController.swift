//
//  JUWInfoViewController.swift
//  Ajuda
//
//  Created by sp4rt4n_0 on 9/26/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

public typealias OnSignOut = ()->()

import UIKit

class JUWInfoViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!

    var onSignOut: OnSignOut?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBarColors()
        customizeUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func customizeUserInterface() {
        let configuration = JUWConfigManager.shared.config
        if let authRequired = configuration?.isAuthRequired {
            signOutButton.isHidden = !authRequired
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func closeSessionAction(_ sender: Any) {
        let session = JUWSession.sharedInstance
        session.signOut { (success) in
            self.dismiss(animated: true, completion:{
                if self.onSignOut != nil {
                    self.onSignOut!()
                }
            })
        }
    }
}
