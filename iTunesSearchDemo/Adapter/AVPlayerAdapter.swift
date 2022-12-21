//
//  AVAudioPlayerAdapter.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import AVFoundation
import MediaPlayer

protocol AVPlayerAdapterDelegate: AnyObject {
    func didStateChange(_ state: AVPlayerState)
    func didCurrentTimeChange(_ currentTime: Double)
}

class AVPlayerAdapter: NSObject {
    
    weak var delegate: AVPlayerAdapterDelegate?
    
    static let shared = AVPlayerAdapter()
    
    private var player: AVPlayer = AVPlayer(playerItem: nil)
    
    private var timeObserverToken: Any?
    
    var status: AVPlayerState = .unknown {
        didSet {
            delegate?.didStateChange(status)
        }
    }
    
    private override init() {
        super.init()
        
        register()
        setupRemoteCommand()
    }
    
    private func register() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
        } catch {
            status = .failed(error)
        }
    }
    
    func load(with url: URL, metaData: AVPlayerMediaMetadata, autoStart: Bool) {
        removePeriodicTimeObserver()
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new, .old, .initial], context: nil)
        player = AVPlayer(playerItem: playerItem)
        updateNowPlayingInfo(metaData: metaData)
        guard autoStart else { return }
        play()
    }
    
    func play() {
        player.play()
        addPeriodicTimeObserver()
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.replaceCurrentItem(with: nil)
        removePeriodicTimeObserver()
    }
}

extension AVPlayerAdapter {
    
    private func addObserver() {
        player.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .old, .initial], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAVPlayerItemPlaybackStalled),
                                               name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAVPlayerItemDidPlayToEndTime),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAVPlayerItemFailedToPlayToEndTime),
                                               name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
        case #keyPath(AVPlayerItem.status):
            switch player.currentItem?.status {
            case .unknown:
                status = .unknown
            case .readyToPlay:
                status = .readyToPlay
            case .failed:
                status = .failed(player.currentItem?.error)
            case .none:
                status = .failed(player.currentItem?.error)
            @unknown default:
                status = .failed(player.currentItem?.error)
            }
        default: break
        }
    }
    
    @objc private func handleAVPlayerItemPlaybackStalled() {
        status = .waitForNetwork
    }
    
    @objc private func handleAVPlayerItemDidPlayToEndTime() {
        status = .playToEnd
    }
    
    @objc private func handleAVPlayerItemFailedToPlayToEndTime(_ notification: Notification) {
        let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
        status = .failed(error)
    }
}

extension AVPlayerAdapter {
    
    private func addPeriodicTimeObserver() {
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: 1.cmTime, queue: .main) { [weak self] cmTime in
            self?.delegate?.didCurrentTimeChange(cmTime.timeInterval)
        }
    }
    
    private func removePeriodicTimeObserver() {
        guard let token = timeObserverToken else { return }
        player.removeTimeObserver(token)
        timeObserverToken = nil
    }
}

extension AVPlayerAdapter {
    
    func updateNowPlayingInfo(metaData: AVPlayerMediaMetadata) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = metaData.albumTitle
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metaData.title
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        
        if let url = URL(string: metaData.imageUrl),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            let artwork = MPMediaItemArtwork.init(image: image)
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupRemoteCommand() {
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.addTarget(self, action: #selector(remotePlay))
        center.pauseCommand.addTarget(self, action: #selector(remotePause))
        center.previousTrackCommand.isEnabled = false
        center.nextTrackCommand.isEnabled = false
    }
    
    @objc func remotePlay() -> MPRemoteCommandHandlerStatus {
        play()
        return .success
    }
    
    @objc func remotePause() -> MPRemoteCommandHandlerStatus {
        pause()
        return .success
    }
}
