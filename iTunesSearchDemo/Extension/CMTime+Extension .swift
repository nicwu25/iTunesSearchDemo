//
//  CMTime+Extension .swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Foundation
import AVFoundation

extension CMTime {
    var timeInterval: TimeInterval {
        return CMTimeGetSeconds(self)
    }
}
