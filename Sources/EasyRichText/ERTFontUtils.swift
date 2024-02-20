//
//  ERTFontUtils.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/2/1.
//

import Foundation
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
}
