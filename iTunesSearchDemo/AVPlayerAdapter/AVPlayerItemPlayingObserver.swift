//
//  AVPlayerItemPlayObserver.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/21.
//

import AVFoundation

class AVPlayerItemPlayingObserver: NSObject {
    
    var handlePlaybackStalled: (() -> Void?)?
    var handleDidPlayToEndTime: (() -> Void?)?
    var handleFailedToPlayToEndTime: ((Error) -> Void?)?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleAVPlayerItemPlaybackStalled),
                                               name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAVPlayerItemDidPlayToEndTime),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAVPlayerItemFailedToPlayToEndTime),
                                               name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
    }
    
    @objc private func handleAVPlayerItemPlaybackStalled() {
        handlePlaybackStalled?()
    }
    
    @objc private func handleAVPlayerItemDidPlayToEndTime() {
        handleDidPlayToEndTime?()
    }
    
    @objc private func handleAVPlayerItemFailedToPlayToEndTime(_ notification: Notification) {
        guard let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error else { return }
        handleFailedToPlayToEndTime?(error)
    }
}
