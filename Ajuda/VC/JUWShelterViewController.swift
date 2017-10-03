//
//  JUWShelterViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

typealias OnResultsFound = (_ result: [JUWCollectionCenter], _ product: String)->()

import UIKit

class JUWShelterViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    var searchController: UISearchController!
    var productSearch: String?
    var onResultsFound: OnResultsFound?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUserInterface()
        customizeNavigationBarColors()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    func customizeUserInterface() {
        searchBar.autocapitalizationType = .none
        title = "Quiero ayudar con..."
        let dismissButton = UIButton()
        dismissButton.setImage(UIImage(named: "closeButtonOrange"), for: .normal)
        dismissButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        dismissButton.addTarget(self, action: #selector(JUWShelterViewController.cancel(_:)), for: .touchUpInside)
        let dismissBarButton = UIBarButtonItem(customView: dismissButton)
        navigationItem.rightBarButtonItem = dismissBarButton
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension JUWShelterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            productSearch = searchText
        }
        else{
            productSearch = nil
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let product = productSearch else {
            return
        }

        JUWCollectionCenterManager().collectionCenters(whichNeed: product) { collectionCenters in
            self.onResultsFound?(collectionCenters, product)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
