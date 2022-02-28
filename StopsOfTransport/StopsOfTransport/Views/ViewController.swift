//
//  ViewController.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 26.02.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    //var networkManager = NetworkManager()
    private var tableViewViewModel: TableViewViewModelType?
    
    //var arrayId = [String]()
    //var arrayLat = [Double]()
    //var arrayLon = [Double]()
    //var arrayName = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewViewModel = TableViewViewModel(onCompletion: {
            self.tableView.reloadData()
        })
        //fetchData()
        
    }
}

//MARK: - Table View Data Source
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewViewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? StopTableViewCell,
            let tableViewViewModel = tableViewViewModel
        else { return UITableViewCell() }
        
        let cellViewModel = tableViewViewModel.cellViewModel(forIndexPath: indexPath)
        cell.cellViewModel = cellViewModel
        return cell
    }
}

//MARK: - Table View Delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableViewViewModel = tableViewViewModel else { return }
        tableViewViewModel.selectRow(atIndexPath: indexPath)
        performSegue(withIdentifier: "showMap", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - Navigation
extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let tableViewViewModel = tableViewViewModel else { return }
        guard identifier == "showMap" else { return }
        if let mapVC = segue.destination as? SecondViewController {
            mapVC.viewModel = tableViewViewModel.viewModelForSelectedRow()
        }
    }
    
}

/*
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
                self.tableView.reloadData()
            }
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
       
        
    }
}
*/

