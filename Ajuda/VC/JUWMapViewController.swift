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
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UINib(nibName: "JUWDetailCalloutAccessoryView", bundle: nil).instantiate(withOwner: self, options: nil)
//        view.addSubview(detailCalloutAccessoryView)
//        detailCalloutAccessoryView.isHidden = true
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
        
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "reuseIdentifier")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named:"circle")
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation {
            return
        }
        let annotation = view.annotation as! JUWMapCollectionCenter
        let views = Bundle.main.loadNibNamed("detailCalloutAccessoryView", owner: nil, options: nil)
        let detailCalloutAccessoryView = views?[0] as! detailCalloutAccessoryView
        
        detailCalloutAccessoryView.labelTitle.text = annotation.name
        detailCalloutAccessoryView.labelSubTitle.text = annotation.address
        
        //Add Button For calling in XIB
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 220, width: 280, height: 30)
        button.backgroundColor = UIColor.darkGray
        detailCalloutAccessoryView.addSubview(button)
        
        annotation.retrieveContacInfotWith(completion: { (resultPhone) in
            if resultPhone.isEmpty {
                button.setTitle("Sin teléfono registrado", for: .normal)
            }
            else {
                button.setTitle(resultPhone, for: .normal)
            }
        }, failure: { (error) in
            button.setTitle("Sin teléfono registrado", for: .normal)
        })
        
        button.addTarget(self, action: #selector(JUWMapViewController.call(_:)), for: .touchUpInside)
        
        detailCalloutAccessoryView.center = CGPoint(x: view.bounds.size.width / 2, y: -detailCalloutAccessoryView.bounds.size.height*0.52)
        view.addSubview(detailCalloutAccessoryView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }


    @IBAction func call(_ sender: UIButton) {
        if let phoneNumber = sender.titleLabel?.text {
            let formatedNumber = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            if let url = URL(string: "tel://\(formatedNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(url)) {
                    if #available(iOS 10.0, *) {
                        application.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    @IBAction func showDetail(_ sender: Any) {
    }
}
