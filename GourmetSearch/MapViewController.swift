//
//  MapViewController.swift
//  GourmetSearch
//
//  Created by moritarikuto on 2022/06/15.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private var shopLatitude: Double = 0.0
    private var shopLongitude: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shopLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: shopLatitude, longitude: shopLongitude)
        let currentLocation = MKCoordinateRegion(center: shopLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(currentLocation, animated: true)
    }
}
