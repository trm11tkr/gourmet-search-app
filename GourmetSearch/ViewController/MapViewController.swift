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
    @IBOutlet weak var addressLabel: UILabel!
    
    var shopLatitude: Double?
    var shopLongitude: Double?
    var shopName: String?
    var shopAddress: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = shopAddress
        guard let shopLatitude = shopLatitude,
              let shopLongitude = shopLongitude,
              let shopName = shopName
        else {
            return
        }
        let shopLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: shopLatitude, longitude: shopLongitude)
        setupMapKit(shopLocation: shopLocation, shopName: shopName)
    }
    
    private func setupMapKit (shopLocation: CLLocationCoordinate2D, shopName: String) {
        let currentLocation = MKCoordinateRegion(center: shopLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(currentLocation, animated: true)
        let pin = MKPointAnnotation()
        pin.title = shopName
        pin.coordinate = shopLocation
        mapView.addAnnotation(pin)
    }
}
