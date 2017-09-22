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
    @IBOutlet weak var callButton: UIButton!
    
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
            let annotation = JUWMapCollectionCenter(title: center.name,
                                                    name: center.name,
                                                    address: center.address,
                                                    latitude: center.latitude,
                                                    longitude: center.longitude,
                                                    phoneNumber: center.phoneNumber,
                                                    identifier: center.centerIdentifier,
                                                    coordinate: CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude))
            mapView.addAnnotation(annotation)
        }
    }

    func lol() {
//        if let annotation = annotation as? Artwork {
//            let identifier = "pin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
//                as? MKPinAnnotationView { // 2
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                // 3
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
//            }
//            return view
//        }
//        return nil
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? JUWMapCollectionCenter {
            print(annotation)
//            if (annotation is MKUserLocation) {
//                return nil
//            }
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "reuseIdentifier")
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

                callButton.setTitle(annotation.phoneNumber, for: .normal)
            }

            if #available(iOS 9.0, *) {
                annotationView?.detailCalloutAccessoryView = detailCalloutAccessoryView
            } else {
                // Fallback on earlier versions
            }

            return annotationView
        }
            return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        detailCalloutAccessoryView.isHidden = false
    }

    @IBAction func call(_ sender: Any) {
    }
    
    @IBAction func showDetail(_ sender: Any) {
    }
}
