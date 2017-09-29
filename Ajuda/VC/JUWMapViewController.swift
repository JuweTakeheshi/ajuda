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
    var currentCenter:JUWMapCollectionCenter!

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var needLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var filterView: UIView!
    @IBOutlet var filterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        customizeUserInterface()
        loadCollectionCenters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func customizeUserInterface() {
        title = "Centros acopio"
        showRightBarButton()
        self.navigationItem.setHidesBackButton(true, animated:false)
        let dismissButton = UIButton()
        dismissButton.setImage(UIImage(named: "infoButtonWhite"), for: .normal)
        dismissButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        dismissButton.addTarget(self, action: #selector(JUWMapViewController.loadInfoVC), for: .touchUpInside)
        
        let dismissBarButton = UIBarButtonItem(customView: dismissButton)
        navigationItem.leftBarButtonItem = dismissBarButton
        navigationController?.navigationBar.tintColor = .white
    }

    func loadCollectionCenters() {
        let collectionCentersManager = JUWCollectionCenterManager()
        collectionCentersManager.updateCollectionCenters(centers: { () in
            let realm = try! Realm()
            let centers = Array(realm.objects(JUWCollectionCenter.self))
            self.load(centers: centers)
        }) { (error) in
            self.displayHandlAlert(title: "Error", message: "Tuvimos un problema al obtener los centros de acopio. Mostraremos los centros de la última actualización; recuerda que podría ser información desactualizada.\nAnte cualquier duda te recomendamos ponerte en contacto con ellos.", completion: {_ in 
                self.loadCentersFromCache()
            })
        }
    }

    func load(centers: [JUWCollectionCenter]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for center in centers {
            let annotation = JUWMapCollectionCenter(title: center.name,
                                                    name: center.name,
                                                    address: center.address,
                                                    phoneNumber: center.phoneNumber,
                                                    identifier: center.centerIdentifier,
                                                    twitter: center.twitterHandle,
                                                    coordinate: CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude))
            mapView.addAnnotation(annotation)
        }
    }

    func loadCentersFromCache() {
        let realm = try! Realm()
        let centersArray = realm.objects(JUWCollectionCenter.self)

        for center in centersArray {
            let annotation = JUWMapCollectionCenter(title: center.name,
                                                    name: center.name,
                                                    address: center.address,
                                                    phoneNumber: center.phoneNumber,
                                                    identifier: center.centerIdentifier,
                                                    twitter: center.twitterHandle,
                                                    coordinate: CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude))
            mapView.addAnnotation(annotation)
        }
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
        guard let phoneNumber = sender.titleLabel?.text else {
            return
        }
        let formatedNumber = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        guard let url = URL(string: "tel://\(formatedNumber)")  else {
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
        let detailCenterNC = sb.instantiateViewController(withIdentifier: "DetailCenterNC") as! UINavigationController
        let detailVC  = detailCenterNC.viewControllers[0] as! DetailCenterVC
        detailVC.center = currentCenter
        present(detailCenterNC, animated: true, completion: nil)
    }

    @IBAction func sendHelp(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "JUWShelterViewController") as! JUWShelterViewController
        searchViewController.onResultsFound = { results, product in
            self.navigationItem.rightBarButtonItem = nil
            self.filterLabel.text = product
            self.filterView.isHidden = false
            self.load(centers: results)
        }

        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func removeFilter(_ sender: UIButton) {
        let realm = try! Realm()
        let centers = Array(realm.objects(JUWCollectionCenter.self))
        load(centers: centers)
        showRightBarButton()
        filterView.isHidden = true
    }
    
    @objc func loadInfoVC() {
        let infoViewController = storyboard?.instantiateViewController(withIdentifier: "JUWInfoViewController") as! JUWInfoViewController
        infoViewController.onSignOut = {
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
        button.frame = CGRect(x: 10, y: 270, width: 260, height: 40)
        button.backgroundColor = UIColor.darkGray
        detailCalloutAccessoryView.addSubview(button)
        //Add button for detail center in XIB
        let btnDetailCenter = UIButton()
        btnDetailCenter.frame = CGRect(x: 10, y: 220, width: 260, height: 40)
        btnDetailCenter.backgroundColor = UIColor.darkGray
        detailCalloutAccessoryView.addSubview(btnDetailCenter)
        
        
        annotation.retrieveContacInfotWith(completion: { (resultPhone) in
            if resultPhone.isEmpty {
                button.setTitle("Sin teléfono registrado", for: .normal)
            }
            else {
                button.setTitle(resultPhone, for: .normal)
            }
        }, failure: { (error) in
            button.setTitle("Sin teléfono", for: .normal)
            button.alpha = 0.5
        })

        annotation.retrieveProductsWith(completion: { (products) in
            
        }) { (error) in
            self.displayOKAlert(title: "Error", message: "Tuvimos un problema al obtener los productos que se necesitan en este centro de acopio. Mostraremos los productos de la ultima actualización recuerda que puede ser información desactualizada.\nAnte cualquier duda te recomendamos ponerte en contacto con ellos.")
            
        }
        currentCenter = annotation
        btnDetailCenter.setTitle("Ver mas", for: .normal)
        btnDetailCenter.addTarget(self, action: #selector(JUWMapViewController.showDetail(_:)), for: .touchUpInside)
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
}
