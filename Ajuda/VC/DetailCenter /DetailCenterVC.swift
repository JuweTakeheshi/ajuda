//
//  DeatilCenterVC.swift
//  Ajuda
//
//  Created by sp4rt4n_0 on 9/23/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit
import RealmSwift

class DetailCenterVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var productsLabel: UITableView!
    @IBOutlet weak var callButton: UIButton!

    var center:JUWMapCollectionCenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUserInterface()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func customizeUserInterface() {
        nameLabel.text = collectionCenter().name
        addressLabel.text = collectionCenter().address
        twitterLabel.text = collectionCenter().twitterHandle
        let phoneNumber = collectionCenter().phoneNumber.isEmpty ? "Sin teléfono registrado" : String.localizedStringWithFormat("%@ (llamar)", collectionCenter().phoneNumber)
        callButton.setTitle(phoneNumber, for: .normal)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func call() {
        let formatedNumber = collectionCenter().phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToAddProduct"{
            let destinationVC = segue.destination as! JUWAddProductViewController
            destinationVC.currentCenter = collectionCenter()
        }
    }
//
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionCenter().products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        cell.textLabel?.text = collectionCenter().products[indexPath.row].name
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy HH:mm a"
        let formattedDateString = String.localizedStringWithFormat("Actualizado - %@", dateformatter.string(from: collectionCenter().products[indexPath.row].updateDate!))
        cell.detailTextLabel?.text = formattedDateString

        return cell
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func collectionCenter() -> JUWCollectionCenter {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "centerIdentifier = %@", center.centerIdentifier)
        return realm.objects(JUWCollectionCenter.self).filter(predicate).first!
    }
}
