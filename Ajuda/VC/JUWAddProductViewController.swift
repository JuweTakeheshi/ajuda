//
//  JUWAddProductViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/25/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class JUWAddProductViewController: UIViewController {
    // MARK: - Properties
    var currentCenter:JUWCollectionCenter!
    
    // MARK: - Outlets
    @IBOutlet weak var addProductTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        addProductTextField.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.displayOKAlert(title: "Aviso", message: "Estás a punto de agregar un producto que este centro de acopio necesita, por favor introduce solamente información verídica y confirmada")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addProductAction(_ sender: Any) {
        addProductTextField.resignFirstResponder()
        if addProductTextField.text != "" {
            showAddProductAlert()
        }
    }
    
    func showAddProductAlert() {
        // Mostrar alerta al usuario pregntando si está seguro que esto que se va a agregar está confirmado como requerido en el centro de acopio...
        self.displayConfirmHandlAlert(title: "Confirmacion", message: "¿Realmente desea agregar este producto a la lista de necesidades para este centro de acopio?"){ action in
            self.addProduct(product:self.addProductTextField.text!)
        }
        
    }
    
    func addProduct(product:String){
        let collectionCenterManager  = JUWCollectionCenterManager()
        collectionCenterManager.addProductToCollectionCenter(collectionCenter: currentCenter, product: product, completion:{
            self.displayOKAlert(title: "Aviso", message: "Producto agregado correctamente")
        }, failure:{ error in
             self.displayOKAlert(title: "Aviso", message: "Tuvimos un problema al tratar de añadir este producto intenta mas tarde")
        })
    }
}

extension JUWAddProductViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            textField.resignFirstResponder()
            showAddProductAlert()
        }
        return true
    }
}
