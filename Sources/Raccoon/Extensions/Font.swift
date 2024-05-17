//
//  Font.swift
//  Raccoon
//
//  Created by devonly on 2023/12/30
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

public extension Font {
    /// Create a custom font with the given `name` and `size` that scales
    /// relative to the given `textStyle`.
    static func custom(_ type: UIFont.SPFontType, size: CGFloat) -> Font {
        Font(UIFont(type, size: size))
    }
}
