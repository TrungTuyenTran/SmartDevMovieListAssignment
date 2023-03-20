//
//  IViewModel.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import Foundation

protocol IViewModel {
    // Binding
    var showErrorPopup: ((String?) -> Void)? { get set }
}
