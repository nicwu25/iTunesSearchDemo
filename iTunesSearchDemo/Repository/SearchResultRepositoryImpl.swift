//
//  SearchResultRepositoryImpl.swift
//  iTunesSearchDemo
//
//  Created by Nic Wu on 2022/12/22.
//

import Foundation

struct SearchResultRepositoryImpl: SearchResultRepository {
    
    let dataSource = APIEngine()
    
    func searchMusic(keyword: String, completion: @escaping (Result<[SearchResultEntity], NetworkError>) -> Void) {
        
        dataSource.searchMusic(keyword: keyword) { result in
            switch result {
            case .success(let result):
                completion(.success(result.results.map{ $0.asSearchResultEntity() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
