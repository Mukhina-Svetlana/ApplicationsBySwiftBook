//
//  TableViewCellViewModel.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 28.02.2022.
//

import Foundation

class TableViewCellViewModel: TableViewCellViewModelType {
    
    private var stop: Stop
    
    var stopName: String {
        return stop.stopName
    }
    
    init(stop: Stop) {
        self.stop = stop
    }
}
