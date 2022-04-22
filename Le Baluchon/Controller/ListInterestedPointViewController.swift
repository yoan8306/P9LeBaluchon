//
//  ListInterestedPointViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 22/04/2022.
//

import UIKit
import CoreLocation
import MapKit

class ListInterestedPointViewController: UIViewController {
var locationManager = CLLocationManager()
var pointOfInterestCategory: MKPointOfInterestCategory?
    var mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private func search(using searchRequest: MKLocalSearch.Request) {
        mapView.region =  MKCoordinateRegion(center: (locationManager.location?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = mapView.region

        // Include only point of interest results. This excludes results based on address matches.
        searchRequest.resultTypes = .pointOfInterest

//        localSearch = MKLocalSearch(request: searchRequest)
//        localSearch?.start { [unowned self] (response, error) in
//            guard error == nil else {
//                self.displaySearchError(error)
//                return
//            }
//
//            self.places = response?.mapItems
//
//            // Used when setting the map's region in `prepareForSegue`.
//            if let updatedRegion = response?.boundingRegion {
//                self.boundingRegion = updatedRegion
//            }
//        }
    }

}

extension ListInterestedPointViewController: CLLocationManagerDelegate {

    private func userLocationRequest() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}
