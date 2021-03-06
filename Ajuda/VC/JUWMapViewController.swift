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
    // MARK: Properties
    fileprivate var currentCenter:JUWMapCollectionCenter!
    fileprivate var locationManager: CLLocationManager!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLabel: UILabel!

    var onSignOut: OnSignOut?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        customizeUserInterface()
        showCollectionCenters()
    }

    func customizeUserInterface() {
        title = "Centros acopio"
        showRightBarButton()
        self.navigationItem.setHidesBackButton(true, animated:false)
        let infoButton = UIButton()
        infoButton.setImage(UIImage(named: "infoButtonWhite"), for: .normal)
        infoButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        infoButton.addTarget(self, action: #selector(JUWMapViewController.presentInfoViewController), for: .touchUpInside)
        
        let dismissBarButton = UIBarButtonItem(customView: infoButton)
        navigationItem.leftBarButtonItem = dismissBarButton
        navigationController?.navigationBar.tintColor = .white
    }

    func showCollectionCenters() {
        JUWCollectionCenterManager().updateCollectionCenters { result in
            switch result {
            case let .success(collectionCenters):
                self.createMapAnnotations(with: collectionCenters!)
            case .failure(_):
                self.showCollectionCentersError()
            }
        }
    }
    
    func showCollectionCentersError() {
        self.displayHandlAlert(
            title: "Error",
            message: "Tuvimos un problema al obtener los centros de acopio. Mostraremos los centros de la última actualización; recuerda que podría ser información desactualizada.\nAnte cualquier duda te recomendamos ponerte en contacto con ellos") { _ in
                self.createMapAnnotations(with: JUWCollectionCenterManager().collectionCentersFromCache())
        }
    }

    func createMapAnnotations(with collectionCenters: [JUWCollectionCenter]) {
        mapView.removeAnnotations(mapView.annotations)
        for center in collectionCenters {
            let annotation = JUWMapCollectionCenter(title: center.name,
                                                    name: center.name,
                                                    address: center.address,
                                                    phoneNumber: center.phoneNumber,
                                                    identifier: center.centerIdentifier,
                                                    twitter: center.twitterHandle,
                                                    coordinate: CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude))
            mapView.addAnnotation(annotation)
        }
        self.startLocationUpdates()
    }

    func showRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Ayudar",
            style: .plain,
            target: self,
            action: #selector(JUWMapViewController.sendHelp(_:))
        )
    }

    @IBAction func call(_ sender: UIButton) {
        let phoneNumber = sender.titleLabel?.text
        guard let formattedNumber = phoneNumber?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: ""),
              let url = URL(string: "tel://\(formattedNumber)") else {
            return
        }
        if (UIApplication.shared.canOpenURL(url)) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func showDetail(_ sender: Any) {
        let sb = UIStoryboard(name: "Products", bundle: nil)
        let detailCenterNC = sb.instantiateViewController(withIdentifier: "JUWCollectionNavigationViewController") as! UINavigationController
        let collectionCenterViewController  = detailCenterNC.viewControllers[0] as! JUWCollectionCenterViewController
        collectionCenterViewController.center = currentCenter
        present(detailCenterNC, animated: true, completion: nil)
    }

    @IBAction func sendHelp(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "JUWShelterViewController") as! JUWShelterViewController
        searchViewController.onResultsFound = { results, product in
            self.navigationItem.rightBarButtonItem = nil
            self.filterLabel.text = product
            self.filterView.isHidden = false
            self.createMapAnnotations(with: results)
        }

        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func removeFilter(_ sender: UIButton) {
        createMapAnnotations(with: JUWCollectionCenterManager().collectionCentersFromCache())
        showRightBarButton()
        filterView.isHidden = true
    }
    
    @objc func presentInfoViewController() {
        let infoViewController = storyboard?.instantiateViewController(withIdentifier: "JUWInfoViewController") as! JUWInfoViewController
        infoViewController.onSignOut = {
            if self.onSignOut != nil{
                self.onSignOut!()
            }
            self.navigationController?.popViewController(animated: true)
        }
        let navigationController = UINavigationController(rootViewController: infoViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

extension JUWMapViewController: MKMapViewDelegate {
    
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
        button.frame = CGRect(x: 10, y: 170, width: 260, height: 40)
        button.backgroundColor = UIColor(red:1.00, green:0.47, blue:0.00, alpha:1.0)
        detailCalloutAccessoryView.addSubview(button)
        //Add button for detail center in XIB
        let btnDetailCenter = UIButton()
        btnDetailCenter.setTitle("Cargando...", for: .normal)
        btnDetailCenter.frame = CGRect(x: 10, y: 120, width: 260, height: 40)
        btnDetailCenter.backgroundColor = UIColor(red:1.00, green:0.47, blue:0.00, alpha:1.0)
        detailCalloutAccessoryView.addSubview(btnDetailCenter)
        
        annotation.retrieveContacInfotWith(completion: { (resultPhone) in
            if resultPhone.isEmpty {
                button.setTitle("Sin teléfono registrado", for: .normal)
            }
            else {
                button.setTitle(resultPhone, for: .normal)
                button.addTarget(self, action: #selector(JUWMapViewController.call(_:)), for: .touchUpInside)
            }
        }, failure: { (error) in
            button.setTitle("Sin teléfono", for: .normal)
            button.alpha = 0.5
        })

        annotation.retrieveProductsWith(completion: { (products) in
            self.currentCenter = annotation
            btnDetailCenter.setTitle("Ver más", for: .normal)
            btnDetailCenter.addTarget(self, action: #selector(JUWMapViewController.showDetail(_:)), for: .touchUpInside)
            
            detailCalloutAccessoryView.center = CGPoint(x: view.bounds.size.width / 2, y: -detailCalloutAccessoryView.bounds.size.height*0.52)
            view.addSubview(detailCalloutAccessoryView)
            mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        }) { (error) in
            self.displayOKAlert(title: "Error", message: "Tuvimos un problema al obtener los productos que se necesitan en este centro de acopio. Mostraremos los productos de la ultima actualización recuerda que puede ser información desactualizada.\nAnte cualquier duda te recomendamos ponerte en contacto con ellos.")
            
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self) {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}

extension JUWMapViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        zoomMapView(with: currentLocation)
    }
    
    private func zoomMapView(with location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }
}
