//
//  EndPoint.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Foundation

protocol EndPoint {
    var baseURL: String { get }
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var encoding: ParameterEncoding { get }
    var headers: [String: String] { get }
}

extension EndPoint {
    
    var baseURL: String {
        "https://itunes.apple.com/"
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get: return .url
        default: return .json
        }
    }
}
