//
//  StopsInfoData.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 27.02.2022.
//

import Foundation

struct StopsInfoData: Decodable {
    let routePath: [RoutePath]
}

struct RoutePath: Decodable {
    let type, number: String
    let timeArrival: [String]
}

