//
//  JUWInfoViewController.swift
//  Ajuda
//
//  Created by sp4rt4n_0 on 9/26/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class JUWInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeSessionAction(_ sender: Any) {
        let session = JUWSession.sharedInstance
        session.signOut { (success) in
            self.dismiss(animated: true, completion:{
                self.parent?.navigationController?.popViewController(animated: true)
            })
            
        }
    }
}
