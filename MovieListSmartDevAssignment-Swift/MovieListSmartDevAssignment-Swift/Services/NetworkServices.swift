//
//  NetworkServices.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import Foundation

protocol INetworkServices {
    func get<T: Decodable>(urlString: String,
                           dataType: T.Type,
                           completion: @escaping (Result<BaseResponse<T>, Error>) -> Void)
}

class NetworkServices: INetworkServices {
    
    //Prevent creating instances from outside the class
    static let shared = NetworkServices()
    
    private init() {}
    
    // Retrieves decodable data from a given URL
    func get<T: Decodable>(urlString: String,
                         dataType: T.Type,
                         completion: @escaping (Result<BaseResponse<T>, Error>) -> Void) {
        guard let url = URL(string: BASE_URL + urlString) else {
            // Calls the completion handler with an error if the URL is invalid
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Creates a data task to retrieve data from the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handles errors if any
                Logger.error(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            // Checks if there is a response and data received
            if let data = data,
               let response = response as? HTTPURLResponse {
                // Checks if the response status code is success
                if response.statusCode == 200 {
                    do {
                        let pagingObject = try JSONDecoder().decode(BaseResponse<T>.self, from: data)
                        Logger.success("Response \(pagingObject)")
                        completion(.success(pagingObject))
                    } catch let error {
                        Logger.error("Error Parsing \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                } else {
                    Logger.error("\(response.statusCode)")
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            }
        }
        task.resume()
    }
}


