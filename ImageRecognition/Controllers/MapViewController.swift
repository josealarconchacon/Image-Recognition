//
//  MapViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/4/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController , UIApplicationDelegate, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    let initialLocation = CLLocationCoordinate2D(latitude: 40.682663, longitude: -73.925383)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
       
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        return true
    }
    @IBAction func zoomView(_ sender: UIButton) {
        if let userLocation = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegion( center: userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(region, animated: true)
        }
    }
    @IBAction func changeView(_ sender: UIBarButtonItem) {
        if mapView.mapType == MKMapType.standard {
            mapView.mapType = MKMapType.satellite
        } else {
            mapView.mapType = MKMapType.standard
        }
    }
    func mapView(_ mapView: MKMapView, didUpdate
        userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "List View"
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationItem.title = "List View"
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "Back"
    }
    ///---
    func getTransitETA() {
        let request = MKDirections.Request()
        let source = MKMapItem(placemark:
            MKPlacemark(coordinate:CLLocationCoordinate2D(latitude: 40.748384, longitude: -73.985479), addressDictionary: nil))
            source.name = "Empire State Building"
            request.source = source
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate:CLLocationCoordinate2D(latitude: 40.643351, longitude: -73.788969), addressDictionary: nil))
            destination.name = "JFK Airport"
            request.destination = destination
            request.transportType = MKDirectionsTransportType.transit
        
        let directions = MKDirections(request: request)
            directions.calculateETA {
                (response, error) -> Void in
            if error == nil {
                if let estimate = response {
                    print("Travel time \(estimate.expectedTravelTime / 60)")
                    print("Departing at \(estimate.expectedDepartureDate)")
                    print("Arriving at \(estimate.expectedArrivalDate)")
                }
            }
        }
    }
}
