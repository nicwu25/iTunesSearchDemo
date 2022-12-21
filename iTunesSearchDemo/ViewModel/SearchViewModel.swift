//
//  SearchViewModel.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func didSearched()
    func searchFailed(error: NetworkError)
}

class SearchViewModel {
    
    weak var delegate: SearchViewModelDelegate?
    
    var results: [SearchResultEntity] = []
    
    private let repository: SearchResultRepository
    
    init(repository: SearchResultRepository) {
        self.repository = repository
    }
    
    func getResult(atIndexPath indexPath: IndexPath) -> SearchResultEntity? {
        if results.indices.contains(indexPath.row) {
            return results[indexPath.row]
        }
        return nil
    }
    
    func searchMusic(keyword: String) {
        repository.searchMusic(keyword: keyword) { result in
            switch result {
            case .success(let results):
                self.results = results
                self.delegate?.didSearched()
            case .failure(let error):
                self.delegate?.searchFailed(error: error)
            }
        }
    }
}
