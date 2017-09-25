//
//  JUWAddProductViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/25/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class JUWAddProductViewController: UIViewController {

    @IBOutlet weak var addProductTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        showAddProductAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAddProductAlert() {
        // Mostrar alerta al usuario pregntando si está seguro que esto que se va a agregar está confirmado como requerido en el centro de acopio...
    }
}
