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

class JUWMapViewController: UIViewController, MKMapViewDelegate {

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
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }

        let reuseId = "test"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.image = UIImage(named:"circle")
            annotationView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        let detailView = UIView()
        detailView.backgroundColor = UIColor.gray
        let widthConstraint = NSLayoutConstraint(item: detailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        detailView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: detailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 140)
        detailView.addConstraint(heightConstraint)
        if #available(iOS 9.0, *) {
            annotationView?.detailCalloutAccessoryView = detailView
        } else {
            // Fallback on earlier versions
        }

        return annotationView
    }
}
