//
//  Logger.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import Foundation

class Logger {
    static func success(_ string: String) {
        #if DEBUG
            print("💚💚💚: " + string)
        #endif
    }
    
    static func error(_ string: String) {
        #if DEBUG
            print("❌❌❌: " + string)
        #endif
    }
    
    static func info(_ string: String) {
        #if DEBUG
        print("💛💛💛: " + string)
        #endif
    }
}
