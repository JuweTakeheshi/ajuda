//
//  JUWMapViewController.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class JUWMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCollectionCenters()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadCollectionCenters() {
        let collectionCentersManager = JUWCollectionCenterManager()
        collectionCentersManager.getCollectionCenters(centers: { () in
            let realm = try! Realm()
            let centersArray = realm.objects(JUWCollectionCenter.self)
            print(centersArray.count)
            
        }) { (error) in
            
        }
    }
    
}
