//
//  ERTFontUtils.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/2/1.
//

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct ERTFontUtils {
    public static let `default` = ERTFontUtils()

    #if canImport(AppKit)
    public func font(_ font: NSFont, with descriptor: NSFontDescriptor) -> NSFont {
        return .init(descriptor: descriptor, size: font.pointSize) ?? font
    }

    public func font(_ font: NSFont, modifyingDescriptor: (NSFontDescriptor) -> NSFontDescriptor) -> NSFont {
        return self.font(font, with: modifyingDescriptor(font.fontDescriptor))
    }

    public func font(_ font: NSFont, with symbolicTraits: NSFontDescriptor.SymbolicTraits) -> NSFont {
        return self.font(font, with: font.fontDescriptor.withSymbolicTraits(symbolicTraits))
    }

    public func font(_ font: NSFont, modifySymbolicTraits: (inout NSFontDescriptor.SymbolicTraits) -> Void) -> NSFont {
        var traits = font.fontDescriptor.symbolicTraits
        modifySymbolicTraits(&traits)
        return self.font(font, with: traits)
    }
    #elseif canImport(UIKit)
    public func font(_ font: UIFont, with descriptor: UIFontDescriptor) -> UIFont {
        return .init(descriptor: descriptor, size: font.pointSize)
    }

    public func font(_ font: UIFont, modifyingDescriptor: (UIFontDescriptor) -> UIFontDescriptor) -> UIFont {
        return self.font(font, with: modifyingDescriptor(font.fontDescriptor))
    }

    public func font(_ font: UIFont, with symbolicTraits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        return self.font(font, with: font.fontDescriptor.withSymbolicTraits(symbolicTraits) ?? font.fontDescriptor)
    }

    public func font(_ font: UIFont, modifySymbolicTraits: (inout UIFontDescriptor.SymbolicTraits) -> Void) -> UIFont {
        var traits = font.fontDescriptor.symbolicTraits
        modifySymbolicTraits(&traits)
        return self.font(font, with: traits)
    }
    #endif

    #if canImport(SwiftUI)
    #if canImport(UIKit)
    public func uiFont(from font: Font) -> UIFont? {
        var attributedString = AttributedString("1")
        attributedString.swiftUI.font = font
        let nsAttributedString = NSAttributedString(attributedString)
        let font = nsAttributedString.attribute(.font, at: 0, effectiveRange: nil) as? UIFont
        return font
    }
    public func ctFont(from font: Font) -> CTFont? {
        uiFont(from: font) as CTFont?
    }
    #elseif canImport(AppKit)
    public func nsFont(from font: Font) -> NSFont? {
        var attributedString = AttributedString("1")
        attributedString.swiftUI.font = font
        let nsAttributedString = NSAttributedString(attributedString)
        let font = nsAttributedString.attribute(.font, at: 0, effectiveRange: nil) as? NSFont
        return font
    }
    public func ctFont(from font: Font) -> CTFont? {
        nsFont(from: font) as CTFont?
    }
    #endif
    #endif
}
