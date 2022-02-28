//
//  ModelInfoStops.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 27.02.2022.
//

import Foundation

struct ModelInfoStops {
    let type, number: String?
    let timeArrival: String?
    init(info: RoutePath) {
        type = info.type
        number = info.number
        timeArrival = info.timeArrival.first ?? nil
    }

}
