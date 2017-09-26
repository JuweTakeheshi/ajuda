//
//  UIButton+ajuda.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/26/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

extension UIButton {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
