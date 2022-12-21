//
//  MockSearchResultRepositoryImpl.swift
//  iTunesSearchDemo
//
//  Created by Nic Wu on 2022/12/22.
//

import Foundation

struct MockSearchResultRepositoryImpl: SearchResultRepository {
    
    func searchMusic(keyword: String, completion: @escaping (Result<[SearchResultEntity], NetworkError>) -> Void) {
        
        let results = [SearchResultEntity(trackName: "Empire State Of Mind (feat. Alicia Keys)", artistName: "JAY-Z", collectionName: "The Blueprint 3", previewURL: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/fe/cb/49/fecb4940-db9f-d90a-8422-994741ec5b1b/mzaf_12689893096021422979.plus.aac.p.m4a", artworkUrl30: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/ef/b7/81/efb781fb-e3e7-e571-696e-5b9ac4a78057/00858786005463.rgb.jpg/30x30bb.jpg", artworkUrl60: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/ef/b7/81/efb781fb-e3e7-e571-696e-5b9ac4a78057/00858786005463.rgb.jpg/60x60bb.jpg", artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/ef/b7/81/efb781fb-e3e7-e571-696e-5b9ac4a78057/00858786005463.rgb.jpg/100x100bb.jpg"), SearchResultEntity(trackName: "LOVE SCENARIO", artistName: "iKON", collectionName: "Return", previewURL: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/51/f9/0f/51f90f28-cf43-2e5f-efc0-b9efa89006a6/mzaf_11692268688381106180.plus.aac.p.m4a", artworkUrl30: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/66/b5/58/66b55853-9c6f-2faa-8193-d646eaa9c61c/iKON_cover.jpg/30x30bb.jpg", artworkUrl60: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/66/b5/58/66b55853-9c6f-2faa-8193-d646eaa9c61c/iKON_cover.jpg/60x60bb.jpg", artworkUrl100: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/66/b5/58/66b55853-9c6f-2faa-8193-d646eaa9c61c/iKON_cover.jpg/100x100bb.jpg")
        ]
        
        completion(.success(results))
    }
}
