//
//  TimeInterval+Extension .swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Foundation
import AVFoundation

extension TimeInterval {
    var cmTime: CMTime {
        return CMTimeMakeWithSeconds(self, preferredTimescale: 600)
    }
}
