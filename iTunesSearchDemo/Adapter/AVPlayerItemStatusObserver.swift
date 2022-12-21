//
//  AVPLayerItemStatusObserver.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/21.
//

import AVFoundation

class AVPlayerItemStatusObserver: NSObject {
    
    private let playerItem: AVPlayerItem
    
    private let playerItemStatusChanged: (AVPlayerItem.Status) -> Void
    
    init(playerItem: AVPlayerItem, callback: @escaping (AVPlayerItem.Status) -> ()) {
        self.playerItem = playerItem
        self.playerItemStatusChanged = callback
        super.init()
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new], context: nil)
    }
    
    deinit {
        playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let change = change,
              let rawStatus = change[.newKey] as? Int,
              let status = AVPlayerItem.Status(rawValue: rawStatus) else { return }
        
        playerItemStatusChanged(status)
    }
}
