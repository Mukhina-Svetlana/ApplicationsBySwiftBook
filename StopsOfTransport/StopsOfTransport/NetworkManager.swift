//
//  NetworkManager.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 26.02.2022.
//

import Foundation

struct NetworkManager{
    
    func fetchCurrentData(completionHandled: @escaping ([Model]) -> Void){
        let urlString = "https://api.mosgorpass.ru/v8.2/stop"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let tast = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentModel = self.parsJson(withData: data){
                    completionHandled(currentModel)
                }
            }
        }
        tast.resume()
    }
    
    func parsJson(withData data: Data) -> [Model]? {
        let decoder = JSONDecoder()
        do {
            let currentData = try decoder.decode(CurrentData.self, from: data)
            var arrayModels = [Model]()
            for i in currentData.data {
                arrayModels.append(Model(currentData: i))
            }
            return arrayModels
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
}
