//
//  MapManager.swift
//  MyPlaces
//
//  Created by Светлана Мухина on 21.01.2022.
//

import UIKit
import MapKit
class MapManager{
    let locationManager = CLLocationManager()
    private var placeCoordinate: CLLocationCoordinate2D?
    private let regionInMeters = 1000.0
    private var directionsArray: [MKDirections] = []
    //маркер заведения
    func setupPlacemark(place: Place, mapView: MKMapView){
        guard let location = place.location else {return}
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true) //маркер с аннотацией
        }
        
    }
    // проверка доступности сервисов геолокации
    func checkLocationServices(mapView: MKMapView, sequeIdentifier: String, closure: ()->()){
        if CLLocationManager.locationServicesEnabled(){
            //setupLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAutoization(mapView: mapView, segueIndentifier: sequeIdentifier)
            closure()
        }else{
            //show alert controller c задержкой 1 секунда
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                self.showAlert(title: "Location services are Disabled", message: "To enable it go: Settings -> Privacy -> Location Services and turn On")
            }
        }
    }
    //разрешение на использование геопозиции/ прверка авторизации приложения для использования сервисов
    func checkLocationAutoization(mapView: MKMapView, segueIndentifier: String){
        //CLLocationManager.authorizationStatus()
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse: //разрешено использовать геопозицию в момент использования
            mapView.showsUserLocation = true
            if segueIndentifier == "getAddres" {showUserLocation(mapView: mapView)}
            break
        case .denied: //отказ использования служб геолокации или отключены
            //откладывает вызов alert controller
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                self.showAlert(title: "Location services are Disabled", message: "To enable it go: Settings -> Privacy -> Location Services and turn On")
            }
            break
        case .notDetermined: //пользователь еще не выбрал можно ли использовать геолокацию
            locationManager.requestWhenInUseAuthorization() //разрешение на использование геолокации в момент использования приложения
            break
        case .restricted: //не авторизвано для использования служб геолокации
            //show alert
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("new case is available")
        }
    }
    //фокус карты на местоопложении пользователя
    func showUserLocation(mapView: MKMapView){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    //прокладывание маршрута
    func getDirections(for mapView: MKMapView, previousLocation: (CLLocation)->()){
        guard let location = locationManager.location?.coordinate else {showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        locationManager.stopUpdatingLocation() //постояннное отслеживание местоположения
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        guard let request = createDirectionRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
                return
        }
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions, mapView: mapView)
        directions.calculate { (response, error)  in
            if let error = error {print(error)}
            guard let response = response else{
                self.showAlert(title: "Error", message: "Direction Is Not Available")
                return
                
            }
            for route in response.routes{
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance/1000)
                let timeInterval = route.expectedTravelTime
                print("расстояние \(distance) км")
                print("время в пути \(timeInterval)")
            }
    }
    }
    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request?{
        guard let destinationCoordinate = placeCoordinate else {return nil}
        let startingLocation = MKPlacemark(coordinate: coordinate) //точка начала маршрута
        let destination = MKPlacemark(coordinate: destinationCoordinate) //конечная точка
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile //вид транспорта
        request.requestsAlternateRoutes = true //несколько альтернативных маршрутов если есть
        return request
    }
    //зона области карты в зависимости от перермещения пользователя
    func startTrakingUserLocation(for mapView: MKMapView, and location: CLLocation?, closure: (_ currentLocation: CLLocation) -> ()) {
//        guard let previousLocation = previousLocation else {
//            return
//        }
        guard let location = location else {return}
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else {return}
        //self.previousLocation = center
        
       // DispatchQueue.main.asyncAfter(deadline: .now()+3) { //задержка 3 секунды в действиях
         //   self.showUserLocation()
        
        //}

        closure(center)
    }
    
    //определение координат центра точки карты
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let shirota = mapView.centerCoordinate.latitude
        let dolgota = mapView.centerCoordinate.longitude
        return CLLocation(latitude: shirota, longitude: dolgota)
    }
    //обнуление ранее построенных маршрутов
    private func resetMapView(withNew directions: MKDirections, mapView: MKMapView){
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map{$0.cancel()}
        directionsArray.removeAll()
        
    }
    
    
    
     func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: title, style: .default)
        alert.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true)
    }
    
    
}
