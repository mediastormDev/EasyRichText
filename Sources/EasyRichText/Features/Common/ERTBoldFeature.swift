//
//  ERTBoldFeature.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/30.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct ERTBoldFeature: ERTSymbolicTraitFeature {
#if canImport(AppKit)
    public static var traits: NSFontDescriptor.SymbolicTraits = .bold
#elseif canImport(UIKit)
    public static var traits: UIFontDescriptor.SymbolicTraits = .traitBold
#endif

    public var isOn: Bool

    public init(value: Bool?) {
        isOn = value ?? false
    }
}
