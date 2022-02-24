//
//  TableViewController.swift
//  MyPlaces
//
//  Created by Светлана Мухина on 28.11.2021.
//

import UIKit
import RealmSwift

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let searchC = UISearchController(searchResultsController: nil)
    private var filtredPlaces: Results<Place>!
    private var searchBarIsEmpty: Bool {
        guard let text = searchC.searchBar.text else {return false} //true, если строка пустая
        return text.isEmpty
    }
    private var places: Results<Place>!
    private var isFiltering: Bool{
        return searchC.isActive && !searchBarIsEmpty
    }
    private var ascendingSorting = true //сортировка по возрастанию
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    // let places = [Place(name: "Burger Heroes", location: "Уфа", type: "Ресторан", image: "Burger Heroes")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        //Настройка SearchController
        searchC.searchResultsUpdater = self
        searchC.obscuresBackgroundDuringPresentation = false
        searchC.searchBar.placeholder = "Search"
        navigationItem.searchController = searchC
        definesPresentationContext = true
        //searchC.isActive = false
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filtredPlaces.count
        }
        return places.count
            //resturanNames.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
       // var place = Place()
        let place = isFiltering ? filtredPlaces[indexPath.row] : places[indexPath.row]
//        if isFiltering{
//            place = filtredPlaces[indexPath.row]
//        } else {
//            place = places[indexPath.row]
//        }
        
        
        //let place = places[indexPath.row]
        cell.namePlace.text = place.name
        cell.locationPlace.text = place.location
        cell.typePlace.text = place.type
//
//        if place.image == nil{
//            cell.imageOfPlace.image = UIImage(named: place.resturantImage!)
//        } else{
//            cell.imageOfPlace.image = place.image
//        }
        cell.imageOfPlace.image = UIImage(data: place.image!)
        cell.cosmosView.rating = place.rating
        
//        //var content = cell.defaultContentConfiguration()
//        //content.text = resturanNames[indexPath.row]
//       // content.image = UIImage(named: resturanNames[indexPath.row])
//        //cell.contentConfiguration = content
//        cell.textLabel?.text = resturanNames[indexPath.row]
//        cell.imageView?.image = UIImage(named: resturanNames[indexPath.row])
//        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
//        cell.imageView?.clipsToBounds = true
//       // cell.textLabel?.text = "Cell"

        return cell
    }
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let place = places[indexPath.row]
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
//            StorageManager.deleteObject(self.places[indexPath.row])
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
 
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail" else {return}
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        //let place = places[indexPath.row]
       // let place: Place
        let place = isFiltering ? filtredPlaces[indexPath.row] : places[indexPath.row]
//        if isFiltering{
//            place = filtredPlaces[indexPath.row]
//        } else{
//            place = places[indexPath.row]
//        }
        let secondScreenVC = segue.destination as! SecondScreen
        secondScreenVC.currentPlace = place
    }

    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        //всегда для массива
        guard let newPlaceVC = segue.source as? SecondScreen else {return}
        newPlaceVC.savePlace()
        //places.append(newPlaceVC.newPlace!)
        tableView.reloadData()
    }

    @IBAction func reversedSortingTapped(_ sender: UIBarButtonItem) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting{
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else{
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
       sorting()
    }
    
    private func sorting(){
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date",ascending: ascendingSorting)
        } else{
            places = places.sorted(byKeyPath: "name",ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}


extension TableViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchC.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ seachText: String){
        filtredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", seachText,seachText)
        tableView.reloadData()
    }
}
