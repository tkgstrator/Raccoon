//
//  UIFont.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation
import OSLog
import SwiftUI
import UIKit

extension UIFont {
    public enum SPFontType: String, CaseIterable {
        case Splatfont1 = "fonts/bundled/ab3ec448c2439eaed33fcf7f31b70b33.woff2"
        case Splatfont2 = "fonts/bundled/da3c7139972a0e4e47dd8de4cacea984.woff2"
        
        var cascadeList: [UIFontDescriptor] {
            fontPaths.compactMap({ fontPath in
                guard let documentURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                      let array: CFArray = CTFontManagerCreateFontDescriptorsFromURL(documentURL.appendingPathComponent(fontPath) as CFURL),
                      let fonts: [CTFontDescriptor] = array as? [CTFontDescriptor],
                      let font: CTFontDescriptor = fonts.first
                else {
                    Logger.error("Could not find \(rawValue) in document directory.")
                    return nil
                }
                return font as UIFontDescriptor
            })
        }
        
        var fontPaths: [String] {
            switch self {
            case .Splatfont1:
                return [
                    "/fonts/bundled/ab3ec448c2439eaed33fcf7f31b70b33.woff2",
                    "/fonts/bundled/0e12b13c359d4803021dc4e17cecc311.woff2",
                ]
            case .Splatfont2:
                return [
                    "/fonts/bundled/da3c7139972a0e4e47dd8de4cacea984.woff2",
                    "/fonts/bundled/eb82d017016045bf998cade4dac1ec22.woff2",
                ]
            }
        }
        
        var descriptor: UIFontDescriptor {
            guard let documentURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                  let array: CFArray = CTFontManagerCreateFontDescriptorsFromURL(documentURL.appendingPathComponent(rawValue) as CFURL),
                  let fonts: [CTFontDescriptor] = array as? [CTFontDescriptor],
                  let font: CTFontDescriptor = fonts.first
            else {
                Logger.error("Could not find \(rawValue) in document directory.")
                return .init()
            }
            return (font as UIFontDescriptor)
                .addingAttributes([UIFontDescriptor.AttributeName.cascadeList: cascadeList])
                .addingAttributes([UIFontDescriptor.AttributeName.matrix: CGAffineTransform(scaleX: 1.0, y: 1.0)])
        }
    }
    
    static let SP1: UIFontDescriptor = {
        SPFontType.Splatfont1.descriptor
    }()
    
    static let SP2: UIFontDescriptor = {
        SPFontType.Splatfont2.descriptor
    }()
    
    public convenience init(_ type: SPFontType, size: CGFloat) {
        switch type {
        case .Splatfont1:
            self.init(descriptor: UIFont.SP1, size: size)
        case .Splatfont2:
            self.init(descriptor: UIFont.SP2, size: size)
        }
    }
}
