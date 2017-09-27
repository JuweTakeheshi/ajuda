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

    var onSignOut: OnSignOut?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBarColors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func closeSessionAction(_ sender: Any) {
        let session = JUWSession.sharedInstance
        session.signOut { (success) in
            self.dismiss(animated: true, completion:{
//                self.parent?.navigationController?.popViewController(animated: true)
                if self.onSignOut != nil {
                    self.onSignOut!()
                }
            })
        }
    }
}
