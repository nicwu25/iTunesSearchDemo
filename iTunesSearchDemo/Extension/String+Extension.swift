//
//  String+Extension.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/21.
//

import Foundation

extension String {
    func urlEncoded() -> String? {
        guard let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) else { return nil }
        return encodeUrlString
    }
}
