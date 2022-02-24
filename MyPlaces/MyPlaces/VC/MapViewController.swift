//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Светлана Мухина on 17.01.2022.
//

import UIKit
import MapKit
import CoreLocation
protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
    
    var mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapPrintImage: UIImageView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var goButton: UIButton!
    
    let annotationIdentifier = "annotationIdentifier"
    var segueIndentifier = ""
    
    var previousLocation: CLLocation?{
        didSet{
            //startTrakingUserLocation()
            mapManager.startTrakingUserLocation(for: mapView, and: previousLocation) { (currentLocation) in
                self.previousLocation = currentLocation
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    self.mapManager.showUserLocation(mapView: self.mapView)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addressLabel.text = ""
        setupMapView()
        //mapManager.checkLocationServices(mapView: mapView, sequeIdentifier: <#T##String#>, closure: <#T##() -> ()#>)

        // Do any additional setup after loading the view.
    }
    @IBAction func centerViewInUserLocation() {
        //центрирование по местоположению пользователя
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    @IBAction func goPressed() {
        mapManager.getDirections(for: mapView) { (location) in
            self.previousLocation = location
        }
    }
    
    @IBAction func donePressed() {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
        
    }
    private func setupMapView(){
        goButton.isHidden = true
        mapManager.checkLocationServices(mapView: mapView, sequeIdentifier: segueIndentifier) {
            mapManager.locationManager.delegate = self
        }
        if segueIndentifier == "showMap"{
            mapPrintImage.isHidden = true
            doneButton.isHidden = true
            addressLabel.isHidden = true
            goButton.isHidden = false
            mapManager.setupPlacemark(place: place, mapView: mapView)
        }
    }
    
    
   
    //службы геолокации
//
//    private func setupLocationManager(){
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
    
    
    
   
    
    
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)as? MKMarkerAnnotationView //для появления булавочки (маркера)
        if annotationView == nil{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true //для отображения аннотации в виде банера
        }
        if let imageData = place.image{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView //справа изображение на банере
        }
            return annotationView
            
    }
    //для воспроизведения центра при смене региона для центра
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder() //преобразование географических координат и названий
        
        if segueIndentifier == "showMap" && previousLocation != nil{ //при смещении фокусировка на пользователе
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.mapManager.showUserLocation(mapView: self.mapView)
            }
        }
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks,error) in
            if let error = error {
                print(error)
                return
            }
            guard let placeMarks = placemarks else {return}
            let placemark = placeMarks.first
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            DispatchQueue.main.async {
                if streetName != nil, buildNumber != nil{
                self.addressLabel.text = "\(streetName!),\(buildNumber!)"
                } else if streetName != nil{
                    self.addressLabel.text = "\(streetName!)"
                }else {self.addressLabel.text = ""}
            }
        }
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
}
extension MapViewController: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        mapManager.checkLocationAutoization(mapView: mapView, segueIndentifier: segueIndentifier)
    }
}
