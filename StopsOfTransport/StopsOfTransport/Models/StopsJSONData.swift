//
//  StopsJSONData.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 28.02.2022.
//

import Foundation

struct StopsJSONData: Decodable {
    let data: [StopData]
}

struct StopData: Decodable {
    let id: String
    let lat, lon: Double
    let name: String
}
