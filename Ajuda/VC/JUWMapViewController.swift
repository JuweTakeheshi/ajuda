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
    @IBOutlet weak var detailCalloutAccessoryView: UIView!
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINib(nibName: "JUWDetailCalloutAccessoryView", bundle: nil).instantiate(withOwner: self, options: nil)
        view.addSubview(detailCalloutAccessoryView)
        detailCalloutAccessoryView.isHidden = true
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

        if detailCalloutAccessoryView != nil {
            let widthConstraint = NSLayoutConstraint(item: detailCalloutAccessoryView,
                                                     attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
            detailCalloutAccessoryView.addConstraint(widthConstraint)

            let heightConstraint = NSLayoutConstraint(item: detailCalloutAccessoryView,
                                                      attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
            detailCalloutAccessoryView.addConstraint(heightConstraint)
        }
        if #available(iOS 9.0, *) {
            annotationView?.detailCalloutAccessoryView = detailCalloutAccessoryView
        } else {
            // Fallback on earlier versions
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
        detailCalloutAccessoryView.isHidden = false
    }

    @IBAction func call(_ sender: Any) {
    }
    
    @IBAction func showDetail(_ sender: Any) {
    }
}
