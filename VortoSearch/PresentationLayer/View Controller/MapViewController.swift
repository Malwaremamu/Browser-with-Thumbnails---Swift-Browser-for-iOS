//
//  MapViewController.swift
//  VortoSearch
//
//  Created by Boyanapalli, Uday (Proagrica) on 5/22/21.
//  Copyright © 2021 Uday Boyanapalli. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    var searchText:String?
    var results:[SearchBO]?
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        showAllBusiness()
        //No check location
        
    }
    
    @IBAction func closeMapView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            if #available(iOS 14.0, *) {
                checkLocationAuthorization()
            } else {
                // Fallback on earlier versions
            }
        } else {
            
        }
    }
    
    func centerViewOnUSerLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
       
    }
    
    @available(iOS 14.0, *)
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .denied:
            break
        case .restricted:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUSerLocation()
            //Updating Location When User is Moving
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func showAllBusiness(){
        if let resultValues = results {
            for values in resultValues {
                let london = MKPointAnnotation()
                london.title = "\(values.name) [\(values.reviewRating) \(values.price)]"
                london.coordinate = CLLocationCoordinate2D(latitude: Double(values.latitude)!, longitude: Double(values.longitude)!)
                mapView.addAnnotation(london)
            }
            
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //Bingo
        if #available(iOS 14.0, *) {
            checkLocationAuthorization()
        } else {
            
        }
    }
}
