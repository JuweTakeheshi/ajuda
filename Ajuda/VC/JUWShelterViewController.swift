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

    @IBOutlet var searchBar: UISearchBar!
    var searchController: UISearchController!
    var productSearch: String?
    var onResultsFound: OnResultsFound?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Quiero ayudar con..."
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancelar",
            style: .plain,
            target: self,
            action: #selector(JUWShelterViewController.cancel(_:))
        )
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension JUWShelterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        productSearch = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let product = productSearch else {
            return
        }

        JUWCollectionCenterManager().collectionCenters(whichNeed: product) { collectionCenters in
            self.onResultsFound?(collectionCenters)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
