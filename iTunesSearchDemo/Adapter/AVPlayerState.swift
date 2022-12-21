//
//  AVPlayerState.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/21.
//

import Foundation

enum AVPlayerState {
    case initialization
    case unknown
    case readyToPlay
    case playing
    case paused
    case stoped
    case failed(Error?)
    case waitingForNetwork
    case playToEnd
}
