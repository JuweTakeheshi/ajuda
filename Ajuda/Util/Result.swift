//
//  Result.swift
//  Ajuda
//
//  Created by Nelida Velazquez on 9/25/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

enum Result<Value, Error> {
    case success(Value?)
    case failure(Error)
}
