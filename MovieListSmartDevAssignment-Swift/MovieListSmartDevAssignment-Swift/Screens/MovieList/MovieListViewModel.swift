//
//  MovieListViewModel.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import Foundation

protocol IMovieListViewModel: IViewModel {
    var reloadData:(() -> Void)? { get set }
    var showLoading: ((Bool) -> Void)? { get set }
    var showErrorPopup: ((String?) -> Void)? { get set }
    
    func initListMovie(text: String)
    func loadMoreListMovie(text: String)
    func getMoviesCount() -> Int
    func getMovie(_ index: Int) -> MovieModel?
}

class MovieListViewModel: IMovieListViewModel {
    // Binding
    var showErrorPopup: ((String?) -> Void)?
    var showLoading: ((Bool) -> Void)?
    var reloadData:(() -> Void)?
    
    // Private variables
    private var repository: MovieUseCase = MovieRepository(service: NetworkServices.shared)
    private var page: Int = 1
    private var totalResult: Int = 0
    
    // Data
    private(set) var movies: [MovieModel] = []
    
    func initListMovie(text: String) {
        self.movies = []
        self.page = 1
        self.showLoading?(true)
        repository.getListMovie(text, page: self.page) { [weak self] result in
            guard let self = self else { return }
            self.showLoading?(false)
            switch result {
            case .success(let movies):
                self.totalResult = movies.total
                self.movies = movies.items
                self.reloadData?()
            case .failure(let error):
                self.showErrorPopup?(error.localizedDescription)
            }
        }
    }
    
    func loadMoreListMovie(text: String) {
        if self.movies.count <= self.totalResult {
            self.page += 1
            repository.getListMovie(text, page: self.page) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let movies):
                    self.totalResult = movies.total
                    self.movies.append(contentsOf: movies.items)
                    self.reloadData?()
                case .failure(let error):
                    self.showErrorPopup?(error.localizedDescription)
                }
            }
        }
    }
    
    func getMoviesCount() -> Int {
        return movies.count
    }
    
    func getMovie(_ index: Int) -> MovieModel? {
        if movies.count <= index { return nil }
        return movies[index]
    }
}
