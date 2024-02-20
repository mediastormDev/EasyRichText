//
//  ERTItalicSynthesizer.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/31.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct ERTItalicSynthesizer {
    public struct SynthesizedItalicKey: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "sb.lao.packages.easyrichtext.SynthesizedItalic"
    }

    public static let `default` = ERTItalicSynthesizer()

    public var fontUtils: ERTFontUtils
    #if canImport(AppKit)
    public var matrix: AffineTransform

    public init(matrix: AffineTransform = .init(m11: 1, m12: 0, m21: 0.2, m22: 1, tX: 0, tY: 0), fontUtils: ERTFontUtils = .default) {
        self.matrix = matrix
        self.fontUtils = fontUtils
    }
    #elseif canImport(UIKit)
    public var matrix: CGAffineTransform

    public init(matrix: CGAffineTransform = .init(a: 1, b: 0, c: 0.2, d: 1, tx: 0, ty: 0), fontUtils: ERTFontUtils = .default) {
        self.matrix = matrix
        self.fontUtils = fontUtils
    }
    #endif

    #if canImport(AppKit)
    @_spi(Internal) public func synthesize(_ font: NSFont) -> NSFont {
        fontUtils.font(font) { descriptor in
            let newTraits = font.fontDescriptor.symbolicTraits.subtracting(.italic)
            let newDescriptor = font.fontDescriptor.withSymbolicTraits(newTraits).withMatrix(matrix)
            return newDescriptor
        }
    }
    #elseif canImport(UIKit)
    @_spi(Internal) public func synthesize(_ font: UIFont) -> UIFont {
        fontUtils.font(font) { descriptor in
            let newTraits = font.fontDescriptor.symbolicTraits.subtracting(.traitItalic)
            let newDescriptor = font.fontDescriptor.withSymbolicTraits(newTraits)?.withMatrix(matrix)
            return newDescriptor ?? descriptor
        }
    }
    #endif

    #if canImport(AppKit)
    func desynthesize(_ font: NSFont) -> NSFont {
        fontUtils.font(font) { descriptor in
            let newTraits = font.fontDescriptor.symbolicTraits.union(.italic)
            let newDescriptor = font.fontDescriptor.withSymbolicTraits(newTraits).withMatrix(.identity)
            return newDescriptor
        }
    }
    #elseif canImport(UIKit)
    func desynthesize(_ font: UIFont) -> UIFont {
        fontUtils.font(font) { descriptor in
            let newTraits = font.fontDescriptor.symbolicTraits.union(.traitItalic)
            let newDescriptor = font.fontDescriptor.withSymbolicTraits(newTraits)?.withMatrix(.identity)
            return newDescriptor ?? descriptor
        }
    }
    #endif

    public func synthesize(_ attributedString: AttributedString) -> AttributedString {
        var attributedString = attributedString

        for run in attributedString.runs {
            #if canImport(AppKit)
            guard let font = run.appKit.font, font.fontDescriptor.symbolicTraits.contains(.italic) else { continue }
            #elseif canImport(UIKit)
            guard let font = run.uiKit.font, font.fontDescriptor.symbolicTraits.contains(.traitItalic) else { continue }
            #endif

            attributedString[run.range].font = synthesize(font)
            attributedString[run.range].synthesizedItalic = true
        }

        return attributedString
    }

    public func desynthesize(_ attributedString: AttributedString) -> AttributedString {
        var attributedString = attributedString

        for run in attributedString.runs {
            guard attributedString[run.range].synthesizedItalic ?? false else { continue }

            #if canImport(AppKit)
            guard let font: NSFont = run.font else { continue }
            #elseif canImport(UIKit)
            guard let font: UIFont = run.font else { continue }
            #endif

            attributedString[run.range].font = desynthesize(font)
            attributedString[run.range].synthesizedItalic = false
        }

        return attributedString
    }
}
