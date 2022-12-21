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
    func didCurrentTimeChange(currentTime: Double)
    func didCurrentTimeChange(progress: Float)
}

class AVPlayerAdapter: NSObject {
    
    weak var delegate: AVPlayerAdapterDelegate?
    
    private var player: AVPlayer = AVPlayer(playerItem: nil)
    
    private var playerItemPlayingObserver: AVPlayerItemPlayingObserver?
    
    private var playerItemStatusObserver: AVPlayerItemStatusObserver?
    
    private var timeObserverToken: Any?
    
    var status: AVPlayerState = .initialization {
        didSet {
            delegate?.didStateChange(status)
        }
    }
    
    var isPlaying: Bool {
        player.rate != 0 && player.error == nil
    }
    
    override init() {
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
        status = .initialization
        removePeriodicTimeObserver()
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        observingPlayerItemStatus(playerItem: playerItem)
        observingPlayerItemPlaying()
        updateNowPlayingInfo(metaData: metaData)
        guard autoStart else { return }
        play()
    }
    
    func play() {
        player.play()
        addPeriodicTimeObserver()
    }
    
    func pause() {
        removePeriodicTimeObserver()
        player.pause()
        status = .paused
    }
    
    func stop() {
        removePeriodicTimeObserver()
        playerItemStatusObserver = nil
        playerItemPlayingObserver = nil
        player.replaceCurrentItem(with: nil)
        status = .stoped
    }
}

extension AVPlayerAdapter {
    
    private func observingPlayerItemStatus(playerItem: AVPlayerItem) {
        playerItemStatusObserver = AVPlayerItemStatusObserver(playerItem: playerItem) { [weak self] status in
            switch status {
            case .unknown:
                self?.status = .unknown
            case .readyToPlay:
                self?.status = .readyToPlay
            case .failed:
                self?.status = .failed(self?.player.currentItem?.error)
            @unknown default:
                self?.status = .unknown
            }
        }
    }
    
    private func observingPlayerItemPlaying() {
        playerItemPlayingObserver = AVPlayerItemPlayingObserver()
        playerItemPlayingObserver?.handlePlaybackStalled = { [weak self] in
            self?.status = .waitingForNetwork
        }
        playerItemPlayingObserver?.handleDidPlayToEndTime = { [weak self] in
            self?.status = .playToEnd
        }
        playerItemPlayingObserver?.handleFailedToPlayToEndTime = { [weak self] error in
            self?.status = .failed(error)
        }
    }
}

extension AVPlayerAdapter {
    
    private func addPeriodicTimeObserver() {
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: 1.cmTime, queue: .main) { [weak self] cmTime in
            self?.status = .playing
            self?.delegate?.didCurrentTimeChange(currentTime: cmTime.timeInterval)
            guard let duration = self?.player.currentItem?.asset.duration else { return }
            self?.delegate?.didCurrentTimeChange(progress: Float(cmTime.timeInterval/duration.timeInterval))
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
