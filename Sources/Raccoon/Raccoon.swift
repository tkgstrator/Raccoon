//
//  Raccoon.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import CoreText
import Foundation
import OSLog
import UIKit

public enum Raccoon {
    private static let manager: FileManager = .default
    // swiftlint:disable:next force_unwrapping
    private static let documentURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @discardableResult
    public static func configure() -> Bool {
        let semaphore: DispatchSemaphore = .init(value: 0)
        Task(priority: .high, operation: {
            do {
                try await configure()
                Logger.info("Configuration is finished.")
                semaphore.signal()
            } catch {
                Logger.error(error.localizedDescription)
                semaphore.signal()
            }
        })
        semaphore.wait()
        return true
    }
    
    private static func getHash() async throws -> Hash {
        // swiftlint:disable:next force_unwrapping
        let url: URL = .init(string: "https://api.lp1.av5ja.srv.nintendo.net/")!
        let data: Data = try await download(url: url)
        guard let stringValue: String = .init(data: data, encoding: .utf8),
              let js: String = stringValue.capture(pattern: #"/static/js/main.([a-f0-9]{8}).js"#, group: 1),
              let css: String = stringValue.capture(pattern: #"/static/css/main.([a-f0-9]{8}).css"#, group: 1)
        else {
            return .init(js: "21288b21", css: "06c4deaf")
        }
        return .init(js: js, css: css)
    }
    
    public static func configure() async throws {
        try await _configure()
        await CTFontManagerRegisterFontDescriptors([UIFont.SP1, UIFont.SP2] as CFArray, .process, true)
    }
    
    private static func _configure() async throws {
        Logger.info("Fetch asset info from SplatNet 3.")
        let urls: [URL] = try await getHash().urls
        Logger.info("Fetch hashes successfully.")
        for url in urls {
            let data: Data = try await download(url: url)
            if let stringValue: String = .init(data: data, encoding: .utf8) {
                // data:image/png;base64
                let pattern: String = #"data:image/png;base64,([\w\/\+=]*)"#
                let dataSet: [Data] = stringValue.capture(pattern: pattern)
                    .compactMap({ $0.capture(pattern: pattern, group: 1) })
                    .compactMap({ Data(base64Encoded: $0, options: .ignoreUnknownCharacters) })
                Logger.info("Image/PNG: \(dataSet.count) in \(url)")
                for data in dataSet {
                    try write(data: data)
                }
                // static/media
                let assetURLs: [URL] =
                    stringValue.capture(pattern: #"static/media/[\w\-\/.]*"#)
                        .compactMap({ .init(string: "https://api.lp1.av5ja.srv.nintendo.net/\($0)") })
                    + stringValue.capture(pattern: #"[\w]*/bundled/[\w\-\/.]*"#)
                        .compactMap({ .init(string: "https://app.splatoon2.nintendo.net/\($0)") })
                let results: [Raccoon.Response] = try await withThrowingTaskGroup(of: Raccoon.Response.self, body: { task in
                    assetURLs.forEach({ assetURL in
                        task.addTask(priority: .background, operation: { [self] in
                            let data: Data = try await fetch(url: assetURL)
                            return .init(url: assetURL, data: data)
                        })
                    })
                    return try await task.reduce(into: [Raccoon.Response](), { results, result in
                        results.append(result)
                    })
                })
                Logger.info("Static/Media: \(results.count) in \(url)")
                try results.forEach({ result in
                    try result.write()
                })
            }
        }
    }
    
    @discardableResult
    private static func fetch(url: URL) async throws -> Data {
        if !FileManager.default.fileExists(atPath: url.documentURL.path) {
            let request: URLRequest = .init(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            try write(url: url.documentURL, data: data)
            return data
        }
        return try .init(contentsOf: url.documentURL)
    }
   
    public static func fetch(urls: [URL]) async throws {
        let assets: [Response] = try await fetch(urls: urls)
        for asset in assets {
            try asset.write()
        }
    }
    
    @discardableResult
    private static func fetch(urls: [URL]) async throws -> [Response] {
        try await withThrowingTaskGroup(of: Response.self, body: { task in
            urls.filter({ !FileManager.default.fileExists(atPath: $0.documentURL.path) }).forEach({ url in
                task.addTask(priority: .background, operation: { [self] in
                    .init(url: url.documentURL, data: try await fetch(url: url))
                })
            })
            return try await task.reduce(into: [Response](), { results, result in
                results.append(result)
            })
        })
    }
    
    @discardableResult
    private static func download(url: URL) async throws -> Data {
        let request: URLRequest = .init(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    private static func write(url targetURL: URL, data: Data) throws {
        let destinationURL: URL = targetURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true)
        }
        try data.write(to: targetURL, options: [.atomic, .completeFileProtection])
    }
    
    private static func write(data: Data) throws {
        let targetURL: URL = documentURL.appendingPathComponent("static/media/\(data.hash(.MD5)).png")
        let destinationURL: URL = targetURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true)
        }
        try data.write(to: targetURL, options: [.atomic, .completeFileProtection])
    }
}

extension Raccoon {
    private struct Hash {
        let js: String
        let css: String
        
        var urls: [URL] {
            [
                "https://api.lp1.av5ja.srv.nintendo.net/static/js/main.\(js).js",
                "https://api.lp1.av5ja.srv.nintendo.net/static/css/main.\(css).css",
                "https://app.splatoon2.nintendo.net/css/83f9f64eae6e00dea3bf00db5ae7359b.css",
                "https://app.splatoon2.nintendo.net/js/257b7712fa290ac5b7a5.js",
            ].compactMap({ .init(string: $0) })
        }
    }
    
    struct Response {
        let url: URL
        let data: Data
        
        func write() throws {
            let destinationURL: URL = documentURL.appendingPathComponent(url.absolutePath, isDirectory: false)
            let targetURL: URL = destinationURL.deletingLastPathComponent()
            if !FileManager.default.fileExists(atPath: targetURL.path) {
                try FileManager.default.createDirectory(at: targetURL, withIntermediateDirectories: true)
            }
            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                try data.write(to: destinationURL, options: [.atomic, .completeFileProtection])
            }
        }
    }
}
