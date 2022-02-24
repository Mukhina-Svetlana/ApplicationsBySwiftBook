//
//  CurrentData.swift
//  Sunny
//
//  Created by Светлана Мухина on 16.02.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation

struct CurrentData: Decodable{
    let name: String
    let main: Main
    let weather: [Weather]
    
}
struct Main: Decodable{
    let temp: Double
    let feels_like: Double
}
struct Weather: Decodable{
    let id: Int
}
