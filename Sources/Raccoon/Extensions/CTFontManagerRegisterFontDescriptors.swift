//
//  CTFontManagerRegisterFontDescriptors.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import CoreText
import Foundation

@available(iOS 13.0, *)
@discardableResult
// swiftlint:disable:next attributes
public func CTFontManagerRegisterFontDescriptors(
    _ fontDescriptors: CFArray,
    _ scope: CTFontManagerScope,
    _ enabled: Bool
) async -> Bool {
    await withCheckedContinuation({ continuation in
        CTFontManagerRegisterFontDescriptors(fontDescriptors, scope, enabled, { theArray, _ in
            let result: Bool = CFArrayGetCount(theArray) == 0
            continuation.resume(returning: result)
            return result
        })
    })
}
