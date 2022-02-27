//
//  ViewController.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 26.02.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var networkManager = NetworkManager()
    var arrayId = [String]()
    var arrayLat = [Double]()
    var arrayLon = [Double]()
    var arrayName = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        fetchData()
        super.viewDidLoad()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrayName[indexPath.row]
        return cell
    }
    
    func fetchData() {
        networkManager.fetchCurrentData { model in
            for i in model{
                self.arrayId.append(i.id)
                self.arrayLat.append(i.lat)
                self.arrayLon.append(i.lon)
                self.arrayName.append(i.name)
            }
            DispatchQueue.main.async {
                //print(self.arrayName)
                self.tableView.reloadData()
            }
            //print(self.arrayName)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showMap"{ return }
        let mapVC = segue.destination as! SecondViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        mapVC.lon = arrayLon[indexPath.row]
        mapVC.lat = arrayLat[indexPath.row]
        mapVC.name = arrayName[indexPath.row]
        mapVC.id = arrayId[indexPath.row]
        //mapVC.setupPlaceMark(latitude: lon, longitude: lat, name: name)
        //mapVC.mapView.centerCoordinate(mapV)
        //mapView.centerToLocation(initialLocation)
        
    }
}


