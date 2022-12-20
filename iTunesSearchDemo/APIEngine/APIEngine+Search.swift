//
//  APIEngine+Search.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Foundation

extension APIEngine {
    
    func searchMusic(keyword: String, completion: @escaping (Result<SearchResultDataModel, NetworkError>) -> Void) {
        request(endPoint: SearchAPI.searchMusic(keyword: keyword)) { result in
            completion(result)
        }
    }
}
