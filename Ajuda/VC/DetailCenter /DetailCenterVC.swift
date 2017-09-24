//
//  DeatilCenterVC.swift
//  Ajuda
//
//  Created by sp4rt4n_0 on 9/23/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class DetailCenterVC: UIViewController {
    // MARK: Properties
    var center:JUWMapCollectionCenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = center.name
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
    
}
