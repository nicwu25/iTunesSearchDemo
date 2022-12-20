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
        let kind: String
        let artistID, collectionID, trackID: Int
        let artistName: String
        let collectionName, trackName, collectionCensoredName, trackCensoredName: String
        let artistViewURL, collectionViewURL, trackViewURL: String
        let previewURL: String
        let artworkUrl30, artworkUrl60, artworkUrl100: String
        let collectionPrice, trackPrice: Double
        let releaseDate: String
        let discCount, discNumber, trackCount, trackNumber: Int
        let trackTimeMillis: Int
        let country: String
        let primaryGenreName: String
        let isStreamable: Bool
        let collectionArtistID: Int?
        let collectionArtistName: String?
        
        enum CodingKeys: String, CodingKey {
            case kind
            case artistID = "artistId"
            case collectionID = "collectionId"
            case trackID = "trackId"
            case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
            case artistViewURL = "artistViewUrl"
            case collectionViewURL = "collectionViewUrl"
            case trackViewURL = "trackViewUrl"
            case previewURL = "previewUrl"
            case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, primaryGenreName, isStreamable
            case collectionArtistID = "collectionArtistId"
            case collectionArtistName
        }
    }
}
