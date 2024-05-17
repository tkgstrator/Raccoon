//
//  URL.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation

extension URL {
    var absolutePath: String {
        let lastPath: String = pathComponents.dropFirst().dropLast().joined(separator: "/")
        let lastPathComponents: [String] = lastPathComponent.components(separatedBy: ".")
        guard let first: String = lastPathComponents.first
        else {
            return "\(lastPath)/\(lastPathComponent)"
        }
        
        // 例外処理
        if lastPathComponents[1] == "83f879de153b7078c66db384c251d126" {
            return "\(lastPath)/work.\(pathExtension)"
        }
        
        guard let fileName: String = first.capture(pattern: #"([a-f0-9]{64})"#, group: 1)
        else {
            return "\(lastPath)/\(first).\(pathExtension)"
        }
        return "\(lastPath)/\(fileName).\(pathExtension)"
    }
    
    var absoluteLastPath: String {
        guard let first: String = lastPathComponent.components(separatedBy: ".").first else {
            return lastPathComponent
        }
        return "\(first).\(pathExtension)"
    }
    
    var documentURL: URL {
        // swiftlint:disable:next force_unwrapping
        let documentURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentURL.appendingPathComponent(absolutePath, isDirectory: false)
    }
}
