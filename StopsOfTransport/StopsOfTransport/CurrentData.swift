//
//  CurrentData.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 26.02.2022.
//

import Foundation

struct CurrentData: Decodable {
    let data: [Datum]
}
struct Datum: Decodable {
    let id: String
    let lat, lon: Double
    let name: String
}
