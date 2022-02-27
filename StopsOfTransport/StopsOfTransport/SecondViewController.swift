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
    var lon, lat : Double?
    var name, id: String?
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var closeButton: UIButton!
    var networkInfoStops = NetworkInfoStops()
    var arryaTypeTransport = [String]()
    var arrayNumberTransport = [String]()
    var arrayTimeArrival = [String?]()
    
    private lazy var showTableView: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Info ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        //button.setTitle("не дави на меня", for: .highlighted)
        button.backgroundColor = .clear
        button.tintColor = .black
       // button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapShowTableView), for: .touchUpInside)
        return button
    }()
    
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
        setupPlaceMark()
        //tap()
        showModal()
        getInfoStops()
        configuration()
    }
    
    
    private func setupPlaceMark() {
        //let geocoder = CLGeocoder()
        
        
        guard let lat = self.lat, let lon = self.lon else {return}
        let location = CLLocation(latitude: lat, longitude: lon)
        let annotation = MKPointAnnotation()
        //annotation.subtitle = self.name
        annotation.coordinate = location.coordinate
        
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        // let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        // annotation.addObserver
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
    }
//    @IBOutlet weak var anotationTap: UIImageView!
//    private func tap(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMe))
//        anotationTap.addGestureRecognizer(tap)
//        anotationTap.isUserInteractionEnabled = true
//    }
    
    @objc func tappedMe(){
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
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
        if arrayNumberTransport.count > 1{
            return 100
        } else {
            NSLayoutConstraint.activate([
                tableView.heightAnchor.constraint(equalToConstant: 100)
            ])
            return 90
        }
    }
    
    func showModal() {
        let modalViewController = ThirdViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
        
    }
    
    func getInfoStops() {
        guard let iD = id else { return }
        networkInfoStops.getDataInfoStops(id: iD) { modelInfo in
            for i in modelInfo{
                self.arryaTypeTransport.append(i.type)
                self.arrayTimeArrival.append(i.timeArrival)
                self.arrayNumberTransport.append(i.number)
            }
            DispatchQueue.main.async {
                //print(self.arrayName)
                self.tableView.reloadData()
            }
            //print(self.arrayName)
        }
    }
    
}
