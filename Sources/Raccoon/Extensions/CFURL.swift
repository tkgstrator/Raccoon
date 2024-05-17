//
//  CFURL.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import CoreText
import Foundation
import UIKit

extension CFURL {
    /// The Core Text Font Descriptor reference.
    var fontDescriptor: UIFontDescriptor? {
        guard let descriptor: CTFontDescriptor = descriptor else {
            return nil
        }
        return (descriptor as UIFontDescriptor)
            .addingAttributes([UIFontDescriptor.AttributeName.cascadeList: descriptor])
            .addingAttributes([UIFontDescriptor.AttributeName.matrix: CGAffineTransform(scaleX: 1.0, y: 1.0)])
    }
   
    /// The Core Text Font Descriptor reference.
    var descriptor: CTFontDescriptor? {
        guard let array: CFArray = CTFontManagerCreateFontDescriptorsFromURL(self),
              let fonts: [CTFontDescriptor] = array as? [CTFontDescriptor],
              let font: CTFontDescriptor = fonts.first
        else {
            return nil
        }
        return font
    }
}

extension Array where Element == CFURL {
    /// This is the type of a reference to immutable CFArrays.
    var descriptors: CFArray {
        compactMap(\.descriptor) as CFArray
    }
}
