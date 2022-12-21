//
//  AVPlayerState.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/21.
//

import Foundation

enum AVPlayerState {
    case unknown
    case readyToPlay
    case failed(Error?)
    case waitForNetwork
    case playToEnd
}
