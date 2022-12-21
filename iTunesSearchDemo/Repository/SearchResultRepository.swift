//
//  SearchResuktRepository.swift
//  iTunesSearchDemo
//
//  Created by Nic Wu on 2022/12/21.
//

import Foundation

protocol SearchResultRepository {
    typealias SearchResult = Result<[SearchResultEntity], NetworkError>
    func searchMusic(keyword: String, completion: @escaping (SearchResult) -> Void)
}
