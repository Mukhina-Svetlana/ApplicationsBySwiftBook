//
//  TableViewViewModelType.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 28.02.2022.
//

import Foundation

protocol TableViewViewModelType {
    
    func numberOfRows() -> Int
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType?
    
    func viewModelForSelectedRow() -> TransportTableViewModelType?
    
    func selectRow(atIndexPath indexPath: IndexPath)
}
