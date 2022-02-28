//
//  SecondViewController.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 26.02.2022.
//

import UIKit
import MapKit

class SecondViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameStop: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closeButton: UIButton!
    
    var lon, lat : Double?
    var name, id: String?
    var networkInfoStops = NetworkInfoStops()
    var viewModel: TransportTableViewModelType?
    
    var arryaTypeTransport = [String]()
    var arrayNumberTransport = [String]()
    var arrayTimeArrival = [String?]()

    private lazy var showTableView: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Info ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .clear
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapShowTableView), for: .touchUpInside)
        return button
    }()
    
    @IBAction func closeTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeInfo(_ sender: UIButton) {
        NSLayoutConstraint.activate([
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
        tableView.isHidden = true
        sender.isHidden = true
        nameStop.isHidden = true
        showTableView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name = viewModel?.stop.stopName
        id = viewModel?.stop.stopId
        lat = viewModel?.stop.latitude
        lon = viewModel?.stop.longitude
        setupPlaceMark()
        networkInfoStops.onCompletion = {
            let alert = UIAlertController(title: "Warning", message: "Error", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { okAction in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        getInfoStops()
        configuration()
    }
    
    private func setupPlaceMark() {
        guard let lat = self.lat, let lon = self.lon else {return}
        let location = CLLocation(latitude: lat, longitude: lon)
        let annotation = MKPointAnnotation()
        //annotation.subtitle = self.name
        annotation.coordinate = location.coordinate
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
//    @objc func tappedMe(){
//        performSegue(withIdentifier: "showDetail", sender: nil)
//    }
}
extension SecondViewController: MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    private func configuration() {
        showTableView.isHidden = true
        nameStop.text = name
        mapView.addSubview(showTableView)
        NSLayoutConstraint.activate([
            showTableView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -60),
            showTableView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 100),
            showTableView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -100)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNumberTransport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTransport", for: indexPath) as! StopsTableViewCell
        cell.number.text = arrayNumberTransport[indexPath.row]
        cell.time.text = arrayTimeArrival[indexPath.row] ?? "NULL"
        let type = arryaTypeTransport[indexPath.row]
        switch type{
        case "bus":
            cell.imageTransport.image = UIImage(named: "Bus")
        case "tram":
            cell.imageTransport.image = UIImage(named: "Tram")
        case "train":
            cell.imageTransport.image = UIImage(named: "Train")
            
        case "subwayHall":
            cell.imageTransport.image = UIImage(named: "Mono")
        case "mcd":
            cell.imageTransport.image = UIImage(named: "Mcd")
            
        default:
            cell.imageTransport.image = UIImage(systemName: "figure.walk")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch arrayNumberTransport.count{
        case 0:
            NSLayoutConstraint.activate([
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            return 0
        case 1:
            NSLayoutConstraint.activate([
                tableView.heightAnchor.constraint(equalToConstant: 100)
            ])
            return 90
        
            default: return 100
            
        }
    }
    
    func getInfoStops() {
        guard let iD = id else { return }
        networkInfoStops.getDataInfoStops(id: iD) { modelInfo in
            for i in modelInfo {
                if let type = i.type, let number = i.number {
                    self.arryaTypeTransport.append(type)
                    self.arrayTimeArrival.append(i.timeArrival)
                    self.arrayNumberTransport.append(number)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @objc
    private func didTapShowTableView(){
        tableView.isHidden = false
        closeButton.isHidden = false
        nameStop.isHidden = false
        NSLayoutConstraint.activate([
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
        showTableView.isHidden = false
    }
}
  



/*
 //MARK: - Table View Data Source
 extension SecondViewController: UITableViewDataSource {
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 5
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTransport")
         return cell!
     }
     
 }

 //MARK: - Table View Delegate
 extension SecondViewController: UITableViewDelegate {
     
 }
 */
