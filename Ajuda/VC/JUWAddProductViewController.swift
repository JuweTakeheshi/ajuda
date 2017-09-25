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
        let message = UIAlertController(title: "Confirmacion", message: "¿Realmente desea agregar este producto a la lista de necesidades para este centro de acopio?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default){ action in
            self.addProduct(product:self.addProductTextField.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler:nil)
        message.addAction(cancelAction)
        message.addAction(okAction)
        self.present(message, animated: true, completion: nil)
    }
    
    func addProduct(product:String){
        let networkManager  = JUWCollectionCenterManager()
        networkManager.addProductToCollectionCenter(collectionCenter: currentCenter, product: product, completion:{
            let message = UIAlertController(title: "Aviso", message: "Producto agregado correctamente", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Aceptar", style: .default){ action in
                self.parent?.dismiss(animated: true, completion: nil)
            }
            message.addAction(okAction)
            self.present(message, animated: true, completion: nil)
        }, failure:{ error in
            let message = UIAlertController(title: "Aviso", message: "Tuvimos un problema al tratar de añadir este producto intenta mas tarde", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Aceptar", style: .default,handler:nil)
            message.addAction(okAction)
            self.present(message, animated: true, completion: nil)
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
