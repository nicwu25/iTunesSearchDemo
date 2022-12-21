//
//  NowPlayingInfoHepler.swift
//  iTunesSearchDemo
//
//  Created by Nic Wu on 2022/12/22.
//

import MediaPlayer
import SDWebImage

class NowPlayingInfoHepler {
    
    private var nowPlayingInfo = [String: Any]()
    
    func update(metaData: AVPlayerMediaMetadata) {
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = metaData.title
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metaData.artist
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        
        guard let url = URL(string: metaData.imageUrl) else {
            updateNowPlayingInfo(nowPlayingInfo)
            return
        }
        
        updateArtwork(imageURL: url)
    }
    
    private func updateArtwork(imageURL: URL) {
        SDWebImageManager().loadImage(with: imageURL, progress: nil) { [unowned self] image, data, error, cacheType, isFinished, imageURL in
            guard let image = image else { return }
            let artwork = MPMediaItemArtwork.init(image: image)
            self.nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
            self.updateNowPlayingInfo(nowPlayingInfo)
        }
    }
    
    private func updateNowPlayingInfo(_ info: [String: Any]) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
}
