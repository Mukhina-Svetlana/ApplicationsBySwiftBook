//
//  CurrentWeather.swift
//  Sunny
//
//  Created by Светлана Мухина on 18.02.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation
struct CurrentWeather{
    
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return "\(temperature.rounded())"
    }
    let feelsLikeTemp: Double
    var felsLikeTemperatureString: String {
        return "\(Int(feelsLikeTemp))"
    }
    
    let conditionCode: Int
    var systemIconNamedString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    init?(currentData: CurrentData){
        cityName = currentData.name
        temperature = currentData.main.temp
        feelsLikeTemp = currentData.main.feels_like
        conditionCode = currentData.weather.first!.id
    }
    
}
