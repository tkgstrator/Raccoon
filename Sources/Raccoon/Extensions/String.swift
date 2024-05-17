//
//  String.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation

extension String {
    func capture(pattern: String, group: Int) -> String? {
        capture(pattern: pattern, group: [group]).first
    }
    
    func capture(pattern: String, group: [Int]) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        guard let matches = regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) else {
            return []
        }
        return group.map { group -> String in
            // swiftlint:disable:next legacy_objc_type
            (self as NSString).substring(with: matches.range(at: group))
        }
    }
    
    func capture(pattern: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        let matches: [NSTextCheckingResult] = regex.matches(in: self, range: NSRange(location: 0, length: count))
        return matches.map { match in
            // swiftlint:disable:next legacy_objc_type
            (self as NSString).substring(with: match.range)
        }
    }
    
    var pascalCase: String {
        if let first: String = components(separatedBy: ".").first {
            return first.components(separatedBy: CharacterSet(charactersIn: "-_")).map({ $0.capitalized }).joined()
        }
        return components(separatedBy: CharacterSet(charactersIn: "-_")).map({ $0.capitalized }).joined()
    }
}
