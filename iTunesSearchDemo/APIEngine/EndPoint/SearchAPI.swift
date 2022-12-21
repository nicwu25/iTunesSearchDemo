//
//  SearchAPI.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Foundation

enum SearchAPI {
    case searchMusic(keyword: String)
}

extension SearchAPI: EndPoint {
    var endPoint: String {
        switch self {
        case .searchMusic(let keyword):
            let term = keyword.replacingOccurrences(of: " ", with: "+")
            let termEncoded = term.urlEncoded() ?? term
            return "search?term=\(termEncoded)&media=music"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchMusic:
            return .get
        }
    }
    
    var parameters: [String : Any] {
        [:]
    }
}
