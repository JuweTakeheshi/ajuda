//
//  UITextField+ajuda.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/26/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

extension UITextField {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
