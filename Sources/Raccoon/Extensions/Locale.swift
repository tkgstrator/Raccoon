//
//  Locale.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation

extension Locale {
    static var `default`: Locale {
        .init(identifier: preferredLanguages[0])
    }
    
    var regionIdentifier: String? {
        if #available(iOS 16.0, macOS 13.0, *) {
            return region?.identifier
        } else {
            return regionCode
        }
    }
    
    var languageIdentifier: String? {
        if #available(iOS 16.0, macOS 13.0, *) {
            return language.languageCode?.identifier
        } else {
            return languageCode
        }
    }
}
