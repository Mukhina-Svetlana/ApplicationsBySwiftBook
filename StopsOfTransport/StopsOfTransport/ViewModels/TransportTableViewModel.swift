//
//  TransportTableViewModel.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 28.02.2022.
//

import Foundation

class TransportTableViewModel: TransportTableViewModelType {
    
    var stop: Stop
    
    init(stop: Stop) {
        self.stop = stop
    }
}
