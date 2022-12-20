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
    
    var searchResult: SearchResultDataModel?
    
    var results: [SearchResultDataModel.Result] {
        searchResult?.results ?? []
    }
    
    func getResult(atIndexPath indexPath: IndexPath) -> SearchResultDataModel.Result? {
        if results.indices.contains(indexPath.row) {
            return results[indexPath.row]
        }
        return nil
    }
}

// MARK: - API Method
extension SearchViewModel {
    
    func searchMusic(keyword: String) {
        APIEngine.shared.searchMusic(keyword: keyword) { result in
            switch result {
            case .success(let searchResult):
                self.searchResult = searchResult
                self.delegate?.didSearched()
            case .failure(let error):
                self.delegate?.searchFailed(error: error)
            }
        }
    }
}
