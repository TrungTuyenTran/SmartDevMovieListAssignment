//
//  MovieRepository.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import Foundation

protocol MovieUseCase {
    func getListMovie(_ string: String, page: Int, completionHandler: @escaping ((Result<(total: Int, items: [MovieModel]), Error>) -> Void))
}

class MovieRepository: MovieUseCase {
    
    private var service: INetworkServices
    
    init(service: INetworkServices) {
        self.service = service
    }
    
    func getListMovie(_ string: String, page: Int, completionHandler: @escaping ((Result<(total: Int, items: [MovieModel]), Error>) -> Void)) {
        service.get(urlString: "?apikey=\(API_KEY)&s=\(string)&type=movie&page=\(page)", dataType: MovieModel.self) { result in
            switch result {
            case .success(let moviesResponse):
                completionHandler(
                    .success((total: Int(moviesResponse.totalResults ?? "0")!,
                                            items: (moviesResponse.Search ?? [])
                             )
                    )
                )
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
