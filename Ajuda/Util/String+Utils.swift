//
//  String+Utils.swift
//  Ajuda
//
//  Created by Nelida Velazquez on 9/25/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import Foundation

extension String {
    func stripCharacters(in set: CharacterSet) -> String {
        return self.components(separatedBy: set).joined(separator: "")
    }
    
    func encoded() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}
