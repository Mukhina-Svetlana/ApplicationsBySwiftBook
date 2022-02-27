//
//  Model.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 26.02.2022.
//

import Foundation

struct Model {
    let id: String
    let lon, lat: Double
    let name: String
    
    init(currentData: Datum) {
       // for i in currentData.data{
        id = currentData.id
        lon = currentData.lon
        lat = currentData.lat
        name = currentData.name
       // }
    }
}
