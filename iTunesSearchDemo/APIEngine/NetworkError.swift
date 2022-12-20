//
//  NetworkError.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Foundation

enum NetworkError: Error {
    case failure(message: String)
    case unableToDecode(errorString: String)
    case unstableInternet
    case noData
    
    func getErrorMessage() -> String {
        switch self {
        case .failure(let message):
            return message
        case .unableToDecode:
            return "Could not decode the response"
        case .unstableInternet:
            return "There is an error with the network connection, please try again later"
        case .noData:
            return "no data"
        }
    }
}
