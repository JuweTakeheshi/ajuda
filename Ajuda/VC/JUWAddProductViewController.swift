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
        customizeUserInterface()
        self.navigationItem.setHidesBackButton(true, animated:false)
        addProductTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.displayOKAlert(title: "Aviso", message: "Estás a punto de agregar un producto que este centro de acopio necesita, por favor introduce solamente información verídica y confirmada")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.q
    }

    func customizeUserInterface() {
        title = "Agregar producto"
        let dismissButton = UIButton()
        dismissButton.setImage(UIImage(named: "backButtonOrange"), for: .normal)
        dismissButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        dismissButton.addTarget(self, action: #selector(JUWAddProductViewController.dismissViewController), for: .touchUpInside)
        
        let dismissBarButton = UIBarButtonItem(customView: dismissButton)
        navigationItem.leftBarButtonItem = dismissBarButton
    }
    
    @IBAction func addProductAction(_ sender: Any) {
        addProductTextField.resignFirstResponder()
        if addProductTextField.text != "" {
            showAddProductAlert()
        }
    }

    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    func showAddProductAlert() {
        // Mostrar alerta al usuario preguntando si está seguro que esto que se va a agregar
        // está confirmado como requerido en el centro de acopio...
        self.displayConfirmHandlAlert(title: "Confirmacion", message: "¿Realmente desea agregar este producto a la lista de necesidades para este centro de acopio?"){ action in
            self.addProduct(product:self.addProductTextField.text!)
        }
        
    }
    
    func addProduct(product:String){
        let collectionCenterManager  = JUWCollectionCenterManager()
        collectionCenterManager.addProductToCollectionCenter(collectionCenter: currentCenter, product: product) { result in
            switch result {
            case .success(_):
                self.displayOKAlert(
                    title: "Aviso",
                    message: "Producto agregado correctamente")
            case .failure(_):
                 self.displayOKAlert(
                    title: "Aviso",
                    message: "Tuvimos un problema al tratar de añadir este producto intenta mas tarde")
            }
        }
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
