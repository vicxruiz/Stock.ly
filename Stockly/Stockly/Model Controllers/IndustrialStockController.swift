//
//  IndustrialStockController.swift
//  Stockly
//
//  Created by Victor  on 6/19/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

class IndustrialStockController {
    //passing data
    let dataGetter = DataGetter()
    let baseURL = URL(string: "https://cloud.iexapis.com")!
    var industrialStocks: [Batch] = []
    var heiStock: Batch?
    var dhrStock: Batch?
    var tdgStock: Batch?
    var zbraStock: Batch?
    var swkStock: Batch?
    var industrialStock: Batch?
    
    func fetchIndustrialStocks(completion: @escaping (Error?) -> Void) {
        //forms url
        var components = URLComponents()
        components.scheme = "https"
        components.host = "cloud.iexapis.com"
        components.path = "/stable/stock/market/batch"
        
        //adds query items
        let queryTokenQuery = URLQueryItem(name: "token", value: "pk_751dcb0db9b34c09a037eaf739af02cb")
        let querySymbolQuery = URLQueryItem(name: "symbols", value: "hei,dhr,tdg,zbra,swk")
        let queryTypesQuery = URLQueryItem(name: "types", value: "quote,news,chart")
        let queryRangeQuery = URLQueryItem(name: "range", value: "1m")
        let queryLastQuery = URLQueryItem(name: "last", value: "5")
        components.queryItems = [queryTokenQuery, querySymbolQuery, queryTypesQuery, queryRangeQuery, queryLastQuery]
        
        print(components.url ?? "no url")
        
        guard let url = components.url else {return}
        
        //Makes request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            //error handling
            if let error = error {
                completion(error)
            }
            guard let data = data else { return }
            
            //decoding
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(IndustrialRoot.self, from: data)
                self.heiStock = data.HEI
                self.dhrStock = data.DHR
                self.tdgStock = data.TDG
                self.zbraStock = data.ZBRA
                self.swkStock = data.SWK
                completion(nil)
            } catch {
                print("error decoding data: \(error)")
                completion(error)
            }
        }
    }
}
