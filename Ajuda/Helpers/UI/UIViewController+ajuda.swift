//
//  UIViewController+ajuda.swift
//  Ajuda
//
//  Created by sp4rt4n_0 on 9/25/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit
extension UIViewController {
    // MARK: - standard alerts
    func displayErrorAlert(title: String, message: String) {
        displayOKAlert(title: title, message: message)
    }
    
    func displayOKAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayHandlAlert(title: String, message: String, completion: @escaping (UIAlertAction) -> Void ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default, handler: completion)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    func displayConfirmHandlAlert(title: String, message: String, completion: @escaping (UIAlertAction) -> Void ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default, handler: completion)
        let actionCancel =  UIAlertAction(title:"Cancelar",style:.destructive)
        alertController.addAction(actionCancel)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

