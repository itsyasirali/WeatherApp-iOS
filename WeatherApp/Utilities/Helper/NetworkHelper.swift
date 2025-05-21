//
//  NetworkHelper.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import Foundation

class NetworkHelper {
    
    static let shared = NetworkHelper()
    private init(){}
    
    func GET(
        apiEndPoint: APIEndPoints,
        params: [RequestParameter: String],
        complete: @escaping (Bool, Data?) -> ()
    ) {
        
        guard var components = URLComponents(string: apiEndPoint.url) else {
            log("Error: cannot create URLCompontents", tag: "NetworkHelper")
            return
        }
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key.rawValue, value: value)
        }
        guard let url = components.url else {
            log("Error: cannot create URL", tag: "NetworkHelper")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                log("Error: problem calling GET\(String(describing: error?.localizedDescription))", tag: "NetworkHelper")
                complete(false, nil)
                return
            }
            guard let data = data else {
                log("Error: did not receive data", tag: "NetworkHelper")
                complete(false, nil)
                return
            }
            print(String(data: data, encoding: .utf8) ?? .empty)
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                log("Error: HTTP request failed", tag: "NetworkHelper")
                complete(false, nil)
                return
            }
            complete(true, data)
        }.resume()
    }
}
