//
//  MapViewController.swift
//  Wunder
//
//  Created by Soham Bhowmik on 10/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var carViewModel: CarViewModel? = nil
    
    var annotationsArray: [MKAnnotation] = []
    
    var currentLocation: CLLocation? = nil
    
    var initialMapRegionSet = false
    
    let popoverViewTag = 103
    let maskViewTag = 104
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    func setupBindings()
    {
        if carViewModel != nil {
            carViewModel?.carArray.bind({ [unowned self] (_) in
                self.annotationsArray = self.createAnnotations(fromCoordinates: self.carViewModel!.getAllCoordinates())
                
                var initialCoordinate = self.annotationsArray.first?.coordinate
                if(initialCoordinate == nil){
                    if self.currentLocation != nil{
                        initialCoordinate = self.currentLocation?.coordinate
                    }
                }
                if(initialCoordinate != nil){
                    if self.initialMapRegionSet == false{
                        self.setMapInitialRegion(inCoordinatee: initialCoordinate!)
                    }
                }
                self.mapView.addAnnotations(self.annotationsArray)
            })
        }
    }
    
    func setupMapView()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.showsUserLocation = true
        mapView.userLocation.title = nil
        mapView.delegate = self
        
        let buttonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    func determineCurrentLocation()
    {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func createAnnotations(fromCoordinates coordinatesArr: [CLLocation]) -> [MKPointAnnotation]
    {
        var annotationsArr: [MKPointAnnotation] = []
        for location in coordinatesArr{
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            annotationsArr.append(annotation)
        }
        
        return annotationsArr
    }
    
    func setMapInitialRegion(inCoordinatee: CLLocationCoordinate2D)
    {
        let center = CLLocationCoordinate2D(latitude: inCoordinatee.latitude, longitude: inCoordinatee.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate
{
    //Map View Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = false
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "mapPin")
        annotationView!.image = pinImage
        
        annotationView?.tag = 101
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotation = view.annotation {
            mapView.removeAnnotations(annotationsArray)
            displayCustomAnnotationPopover(fromFrame: view.frame, forAnnotation: annotation)
        }
    }
    
    func displayCustomAnnotationPopover(fromFrame frame:CGRect, forAnnotation annotation: MKAnnotation)
    {
        addMaskView()
        
        let popoverView = Bundle.main.loadNibNamed("CustomMapPopoverView", owner: self, options: nil)?.first as! CustomMapPopoverView
        popoverView.translatesAutoresizingMaskIntoConstraints = false
        popoverView.tag = popoverViewTag
        popoverView.delegate = self
        mapView.addSubview(popoverView)
        
        //
        let latitude = annotation.coordinate.latitude
        let longitude = annotation.coordinate.longitude
        popoverView.carNameLabel.text = carViewModel?.nameOfCarPresentIn(latitude: latitude, longitude: longitude)
        //---
        
        popoverView.widthAnchor.constraint(equalToConstant: popoverView.frame.size.width).isActive = true
        popoverView.heightAnchor.constraint(equalToConstant: popoverView.frame.size.height).isActive = true
        popoverView.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -(self.mapView.frame.size.height - (frame.origin.y + frame.size.height))).isActive = true
        popoverView.leadingAnchor.constraint(equalTo: self.mapView.leadingAnchor, constant: (frame.origin.x + frame.size.width/2 - popoverView.frame.size.width/2)).isActive = true
    }
    
    func addMaskView(){
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(MapViewController.mapViewPressed(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(button)
        
        button.widthAnchor.constraint(equalToConstant: mapView.frame.size.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: mapView.frame.size.height).isActive = true
        button.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 0).isActive = true
        button.leadingAnchor.constraint(equalTo: self.mapView.leadingAnchor, constant: 0).isActive = true
        
        button.tag = maskViewTag
    }
    
    @objc private func mapViewPressed(_ sender: UIButton)
    {
        didTapCustomMapPopover(nil)
    }
}




extension MapViewController: CLLocationManagerDelegate
{
    //Location Manager Delegates
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
            
        case .notDetermined:
            //display appropiate error
            break
            
        case .restricted:
            //error
            break
            
        case .denied:
            //error
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        
        setMapInitialRegion(inCoordinatee: userLocation.coordinate)
        initialMapRegionSet = true

        
        currentLocation = userLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

extension MapViewController: CustomMapPopoverDelegate
{
    func didTapCustomMapPopover(_ popover: CustomMapPopoverView?)
    {
        mapView.viewWithTag(maskViewTag)?.removeFromSuperview()
        mapView.viewWithTag(popoverViewTag)?.removeFromSuperview()
        mapView.addAnnotations(annotationsArray)

    }
}
