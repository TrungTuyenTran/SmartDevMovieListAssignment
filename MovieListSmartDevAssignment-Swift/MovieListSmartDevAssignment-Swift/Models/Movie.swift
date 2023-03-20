//
//  Movie.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import Foundation

struct MovieModel: Codable {
    var title: String?
    var year: String?
    var imdbID: String?
    var type: String?
    var poster: String?
    
    enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
