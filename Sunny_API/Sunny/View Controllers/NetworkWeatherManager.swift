//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Светлана Мухина on 16.02.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation

protocol NetworkWeatherManagerDelegate: AnyObject{
    func updateInterface(currentWeather: CurrentWeather)
}

class NetworkWeatherManager{
    
   // var onCompletion: ((CurrentWeather) -> Void)?
    weak var delegate: NetworkWeatherManagerDelegate?
    func currentWeather(forCity city: String){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=3d309d6b56dfa52cebda1c22d7512940&units=metric"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let tast = session.dataTask(with: url) { data, response, error in
            if let data = data{
                if let currentWeather = self.parsJSON(withData: data)
                {
                    self.delegate?.updateInterface(currentWeather: currentWeather)
                  //  self.onCompletion?(currentWeather)
               // let dataString = String(data: data, encoding: .utf8)
               // print(dataString)
                }
            }
                
        }
        tast.resume()
        
    }
    func parsJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do{
            
            let currentData = try decoder.decode(CurrentData.self, from: data)
           // print(currentData.main.temp)
            guard let currentWeather  = CurrentWeather(currentData: currentData) else {return nil}
            return currentWeather
            
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
}
