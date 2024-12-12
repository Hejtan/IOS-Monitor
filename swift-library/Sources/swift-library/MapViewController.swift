import UIKit
import MapKit
import CoreLocation

// <key>NSLocationWhenInUseUsageDescription</key>
// <string>We need your location to center the map.</string>


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager() // For accessing user's location
    var selectedCoordinate: CLLocationCoordinate2D? // Stores the pin's coordinates

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Set up the map
        mapView.delegate = self
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        // Request location permissions
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true // Show the user's location on the map
        
        // Add a long press gesture to add a pin
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
        
        // Add buttons
        setupButtons()
    }
    
    func setupButtons() {
        // Button to center map on user's location
        let userLocationButton = UIButton(type: .system)
        userLocationButton.setTitle("Center on Me", for: .normal)
        userLocationButton.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 20, width: 150, height: 40)
        userLocationButton.addTarget(self, action: #selector(centerOnUserLocation), for: .touchUpInside)
        view.addSubview(userLocationButton)
        
        // Button to center map on pin
        let pinLocationButton = UIButton(type: .system)
        pinLocationButton.setTitle("Go to Pin", for: .normal)
        pinLocationButton.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 70, width: 150, height: 40)
        pinLocationButton.addTarget(self, action: #selector(centerOnPin), for: .touchUpInside)
        view.addSubview(pinLocationButton)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let locationInView = gesture.location(in: mapView)
            let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            // Remove existing annotations
            mapView.removeAnnotations(mapView.annotations)
            
            // Add a new annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Selected Location"
            mapView.addAnnotation(annotation)
            
            // Save the coordinate
            selectedCoordinate = coordinate
        }
    }
    
    @objc func centerOnUserLocation() {
        guard let userLocation = locationManager.location else {
            let alert = UIAlertController(title: "Error", message: "Unable to determine your location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func centerOnPin() {
        guard let pinCoordinate = selectedCoordinate else {
            let alert = UIAlertController(title: "Error", message: "No pin has been placed on the map.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let region = MKCoordinateRegion(center: pinCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    // Handle location permission changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            let alert = UIAlertController(title: "Location Access Denied", message: "Please enable location permissions in settings to use this feature.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
