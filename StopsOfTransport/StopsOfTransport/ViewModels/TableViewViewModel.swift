//
//  TableViewViewModel.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 28.02.2022.
//

import Foundation

class TableViewViewModel: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var stops: [Stop]? //[Stop(stopName: "Svetik"), Stop(stopName: "Sergey")]
    
    //var networkManager = NetworkManager()
    let onCompletion: () -> ()
    
    init(onCompletion: @escaping () -> ()) {
        self.onCompletion = onCompletion
        getData()
    }
    
    func numberOfRows() -> Int {
        guard let stops = stops else { return 0 }
        return stops.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        guard let stops = stops else { return nil }
        let stop = stops[indexPath.row]
        return TableViewCellViewModel(stop: stop)
    }
    
    func viewModelForSelectedRow() -> TransportTableViewModelType? {
        guard let selectedIndexPath = selectedIndexPath, let stops = stops else { return nil }
        return TransportTableViewModel(stop: stops[selectedIndexPath.row])
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    private func getData() {
        let urlString = "https://api.mosgorpass.ru/v8.2/stop"
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            self.parseJson(withData: data)
        }.resume()
    }
    
    private func parseJson(withData data: Data) {
        let decoder = JSONDecoder()
        do {
            let stopsData = try decoder.decode(StopsJSONData.self, from: data)
            prepareStops(withStopsData: stopsData)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    private func prepareStops(withStopsData stopsData: StopsJSONData) {
        var stops = [Stop]()
        for stopData in stopsData.data {
            stops.append(Stop(stopData: stopData))
        }
        self.stops = stops
        DispatchQueue.main.async {
            self.onCompletion()
        }
    }
}
    
//    func fetchData() {
//        networkManager.fetchCurrentData { model in
//            for i in model{
//                self.arrayId.append(i.id)
//                self.arrayLat.append(i.lat)
//                self.arrayLon.append(i.lon)
//                self.arrayName.append(i.name)
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//}
