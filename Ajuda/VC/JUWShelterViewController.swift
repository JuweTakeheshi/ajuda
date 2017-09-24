//
//  JUWShelterViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

typealias OnResultsFound = (_ result: [JUWCollectionCenter])->()

import UIKit

class JUWShelterViewController: UIViewController {

    var onResultsFound: OnResultsFound?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cuando tengas los resultados, llamas un bloque así:
        let resultsFromYourSearch = [JUWCollectionCenter]()
        onResultsFound!(resultsFromYourSearch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
