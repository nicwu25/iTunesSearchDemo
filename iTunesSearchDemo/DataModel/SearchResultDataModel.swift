//
//  SearchResultDataModel.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Foundation

struct SearchResultDataModel: Codable {
    let resultCount: Int
    let results: [Result]
}

extension SearchResultDataModel {
    struct Result: Codable {
        let trackName, artistName, collectionName: String
        let previewUrl: URL
        let artworkUrl30, artworkUrl60, artworkUrl100: String
    }
}
