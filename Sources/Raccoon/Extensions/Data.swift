//
//  Data.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import CryptoKit
import Foundation

extension Data {
    public enum Algorithm {
        case MD5
        case SHA1
    }
    
    /// Hex hash string
    func hash(_ algorithm: Algorithm) -> String {
        switch algorithm {
        case .MD5:
            return Insecure.MD5.hash(data: self).map({ String(format: "%02x", $0) }).joined()
        case .SHA1:
            return Insecure.SHA1.hash(data: self).map({ String(format: "%02x", $0) }).joined()
        }
    }
}
