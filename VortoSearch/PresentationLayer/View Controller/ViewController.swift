//
//  ViewController.swift
//  VortoSearch
//
//  Created by Boyanapalli, Uday (Proagrica) on 5/21/21.
//  Copyright © 2021 Uday Boyanapalli. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var tbleViewSerach: UITableView!
    let headers: HTTPHeaders = [
       "Authorization": "Bearer ",
        "Accept": "application/json"
    ]
    var results = [SearchBO]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tbleViewSerach.delegate = self
        self.tbleViewSerach.dataSource = self
        tbleViewSerach.register(UINib(nibName: "SearchListTableViewCell", bundle: nil), forCellReuseIdentifier: "searchTableview")
        

    }
    @IBAction func btnSearchClicked(_ sender: Any) {
        if let serachText = self.txtFldSearch.text{
            self.getSearchResult(searchText: serachText)
        }
    }
    
    @IBAction func btnMapClicked(_ sender: Any) {
        performSegue(withIdentifier: "mapSegueIdentifier", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegueIdentifier" {
            let mapVC = segue.destination as! MapViewController
            mapVC.results = self.results
        }
    }
  
    
}

extension ViewController {
    
   func getSearchResult(searchText:String){
        results = []
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        var lat = 0.0
        var long = -0.0
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
           lat = currentLoc.coordinate.latitude
           long = currentLoc.coordinate.longitude
        }
        AF.request("https://api.yelp.com/v3/businesses/search?term=\(searchText)&latitude=\(lat)&longitude=\(long)",headers: headers)
        .responseJSON { response in
            switch response.result{
            case .success(let value):
                if let json = value as? [String:Any]{
                    print("result is ",json)
                    if let arrBusiness = json["businesses"] as? Array<AnyObject>{
                        for business in arrBusiness {
                            let name = business["name"] as! String
                         
                            var  address = "Not found"
                            if let location = business["location"] as? AnyObject {
                                if let _address = location["address1"] as? String {
                                    address = _address
                                }
                            }
                            
                            let rating = (business["rating"] as? NSNumber)!.stringValue
                            let price = business["price"] as? String
                            let distance = (business["distance"] as! NSNumber).stringValue
                            var latitude = "0.0"
                            var longitude = "0.0"
                            if let coordinates = business["coordinates"] as? AnyObject {
                                if let _latitude = coordinates["latitude"] {
                                    latitude = (_latitude as? NSNumber)!.stringValue
                                }
                                if let _longitude = coordinates["longitude"] {
                                    longitude = (_longitude as? NSNumber)!.stringValue
                                }
                            }
                            
                            let searchBO = SearchBO(name:name, reviewRating: rating, address:address,distance:distance, latitude: latitude, longitude: longitude, price: price ?? "")
                            self.results.append(searchBO)

                        }
                        
                        DispatchQueue.main.async {
                            self.tbleViewSerach.reloadData()
                        }
                        
                    }
                    
                }
            case .failure(_):
                print("Error")
            }
        }
//https://www.yelp.com/developers/documentation/v3/get_started
//https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972
        
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier:"searchTableview", for: indexPath) as! SearchListTableViewCell
        let searchItem = self.results[indexPath.row]
        cell.name?.text = "Name: \(searchItem.name)"
        cell.address.text = "Address: \(searchItem.address)"
        cell.rating.text = "Rating: \(searchItem.reviewRating)"
        cell.distance.text = "Price: \(searchItem.price)"
        return cell
    }
    
    
}
