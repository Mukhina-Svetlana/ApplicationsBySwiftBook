//
//  NetworkInfoStops.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 27.02.2022.
//

import Foundation
import UIKit

class NetworkInfoStops {
    
    var onCompletion: (() -> ())!
    
    func getDataInfoStops(id: String, completionHandled: @escaping ([ModelInfoStops]) -> Void) {
        let urlString = "https://api.mosgorpass.ru/v8.2/stop/" + id
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let tast = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let currentModel = self.parsJsonInfoStops(withData: data){
                
                completionHandled(currentModel)
            }
        }
        tast.resume()
    }
    
    func parsJsonInfoStops(withData data: Data) -> [ModelInfoStops]? {
        let decoder = JSONDecoder()
        do {
            let currentData = try decoder.decode(StopsInfoData.self, from: data)
            var arrayInfoData = [ModelInfoStops]()
            for i in currentData.routePath {
                arrayInfoData.append(ModelInfoStops(info: i))
            }
            return arrayInfoData
        } catch let error as NSError{
            print(error.localizedDescription)
            onCompletion()
        }
        return nil
    }
}
