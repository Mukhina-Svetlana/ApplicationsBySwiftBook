//
//  Stop.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 28.02.2022.
//

import Foundation

struct Stop {
    let stopName: String
    let stopId: String
    let latitude: Double
    let longitude: Double
    
    init(stopData: StopData) {
        self.stopName = stopData.name
        self.stopId = stopData.id
        self.latitude = stopData.lat
        self.longitude = stopData.lon
    }
}
