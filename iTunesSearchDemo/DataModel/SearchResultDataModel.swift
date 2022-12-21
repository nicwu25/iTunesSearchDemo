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
        let wrapperType: String
        let kind: String
        let artistID, trackID: Int
        let collectionID: Int?
        let artistName: String
        let collectionName, collectionCensoredName: String?
        let trackName, trackCensoredName: String
        let collectionArtistID: Int?
        let collectionArtistName: String?
        let collectionArtistViewURL, collectionViewURL: String?
        let artistViewURL, trackViewURL: String
        let previewURL: String
        let artworkUrl30, artworkUrl60, artworkUrl100: String
        let collectionPrice, trackPrice: Double
        let releaseDate: String
        let collectionExplicitness, trackExplicitness: String
        let discCount, discNumber, trackCount, trackNumber: Int?
        let trackTimeMillis: Int
        let country: String
        let currency: String
        let primaryGenreName: String
        let isStreamable: Bool?
        
        enum CodingKeys: String, CodingKey {
            case wrapperType, kind
            case artistID = "artistId"
            case collectionID = "collectionId"
            case trackID = "trackId"
            case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
            case collectionArtistID = "collectionArtistId"
            case collectionArtistName
            case collectionArtistViewURL = "collectionArtistViewUrl"
            case artistViewURL = "artistViewUrl"
            case collectionViewURL = "collectionViewUrl"
            case trackViewURL = "trackViewUrl"
            case previewURL = "previewUrl"
            case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable
        }
    }
}

extension SearchResultDataModel.Result {
    
    func asSearchResultEntity() -> SearchResultEntity {
        SearchResultEntity(trackName: trackName,
                           artistName: artistName,
                           collectionName: collectionName ?? "",
                           previewURL: previewURL,
                           artworkUrl30: artworkUrl30,
                           artworkUrl60: artworkUrl60,
                           artworkUrl100: artworkUrl100)
    }
}
