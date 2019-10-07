//
//  StockController.swift
//  Stockly
//
//  Created by Victor  on 6/13/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

class StockController {
    //MARK: Properties
    
    //passing data
    let dataGetter = DataGetter()
    let baseURL = URL(string: "https://cloud.iexapis.com")!
    var stocks: [Stock] = []
    var quote: Quote?
    var news: [News] = []
    var chart: [Chart] = []
    var stock: Stock?
    var stockBatch: Batch?
    var stockLogoURL: String?
    var searchStocks: [SearchStock] = []
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    func fetchSector(completion: @escaping (Error?) -> Void) {
        //forms url
        var components = URLComponents()
        components.scheme = "https"
        components.host = "cloud.iexapis.com"
        components.path = "/stable/stock/market/collection/sector"
        
        //adds query items
        let queryItemQuery = URLQueryItem(name: "token", value: "pk_751dcb0db9b34c09a037eaf739af02cb")
        let queryCollectionItemQuery = URLQueryItem(name: "collectionName", value: "Technology")
        components.queryItems = [queryItemQuery, queryCollectionItemQuery]
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
                let data = try decoder.decode([Stock].self, from: data)
                self.stocks = data
                completion(nil)
            } catch {
                print("error decoding data: \(error)")
                completion(error)
            }
        }
    }
    
    func fetchStock(_ stock: String, completion: @escaping (Error?) -> Void) {
        //forms url
        var components = URLComponents()
        components.scheme = "https"
        components.host = "cloud.iexapis.com"
        components.path = "/stable/stock/\(stock.lowercased())/batch"
        
        //adds query items
        let queryTokenQuery = URLQueryItem(name: "token", value: "pk_751dcb0db9b34c09a037eaf739af02cb")
        let queryTypesQuery = URLQueryItem(name: "types", value: "quote,news,chart")
        let queryRangeQuery = URLQueryItem(name: "range", value: "1m")
        let queryLastQuery = URLQueryItem(name: "last", value: "5")
        components.queryItems = [queryTokenQuery, queryTypesQuery, queryRangeQuery, queryLastQuery]
        
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
                let data = try decoder.decode(Batch.self, from: data)
                self.quote = data.quote
                self.news = data.news
                self.chart = data.chart
                completion(nil)
            } catch {
                print("error decoding data: \(error)")
                completion(error)
            }
        }
    }
    
    func fetchLogo(_ stock: String, completion: @escaping (Error?) -> Void) {
        //forms url
        var components = URLComponents()
        components.scheme = "https"
        components.host = "cloud.iexapis.com"
        components.path = "/stable/stock/\(stock.lowercased())/logo"
        
        //adds query items
        let queryTokenQuery = URLQueryItem(name: "token", value: "pk_751dcb0db9b34c09a037eaf739af02cb")
        components.queryItems = [queryTokenQuery]
        
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
                let data = try decoder.decode(Logo.self, from: data)
                self.stockLogoURL = data.url
                completion(nil)
            } catch {
                print("error decoding data: \(error)")
                completion(error)
            }
        }
    }
    
    func getData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let jsonUrl = url
        var request = URLRequest(url: jsonUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            completion(data, error)
            }.resume()
    }
    
    func searchStock(with searchTerm: String, completion: @escaping ([SearchStock]?, Error?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "cloud.iexapis.com"
        components.path = "/stable/search/\(searchTerm)"
        
        //adds query items
        //adds query items
        let queryTokenQuery = URLQueryItem(name: "token", value: "pk_751dcb0db9b34c09a037eaf739af02cb")
        components.queryItems = [queryTokenQuery]
               
        print(components.url ?? "no url")
        guard let url = components.url else {
            print("no url")
            return
        }
        //Makes request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            //error handling
            if let error = error {
                completion(nil, error)
            }
            guard let data = data else { return }
            
            //decoding
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode([SearchStock].self, from: data)
                completion(data, nil)
            } catch {
                print("error decoding data: \(error)")
                completion(nil, error)
            }
        }
    }
}

