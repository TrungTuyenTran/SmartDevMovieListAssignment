//
//  BaseResponse.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let Response: String?
    let totalResults: String?
    let Search: [T]?
}
