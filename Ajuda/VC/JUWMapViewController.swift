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
            self.loadCenters()
        }) { (error) in
            
        }
    }

    func loadCenters() {
        let realm = try! Realm()
        let centersArray = realm.objects(JUWCollectionCenter.self)

        for center in centersArray {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
            print(center.latitude, center.longitude)
            annotation.title = center.name

            mapView.addAnnotation(annotation)
        }
//        print(centersArray.count)
    }

//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//
//    }
}
