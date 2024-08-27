//
//  ERTRichTextEditContext.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/31.
//

import Foundation
import Combine
import CoreText
@_spi(Internal) import EasyRichText

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif


public class ERTRichTextEditContext<RichText: ERTRichText>: ObservableObject {
    @Published public private(set) var richText: RichText
    @Published public private(set) var selectedRange: NSRange?
    var nsAttributedString: NSMutableAttributedString
    public var defaultFont: CTFont {
        didSet {
            nsAttributedString = Self.nsAttributedString(
                from: richText,
                italicSynthesizer: italicSynthesizer,
                defaultFont: defaultFont,
                attributedStringBridge: attributedStringBridge
            )
        }
    }
    var onTextUpdated: ((NSAttributedString) -> ())?
    public var onEndEditing: (() -> ())?

    let italicSynthesizer: ERTItalicSynthesizer?
    let attributedStringBridge: ERTAttributedStringBridge
    let fontUtils: ERTFontUtils

    static func nsAttributedString(
        from richText: RichText,
        italicSynthesizer: ERTItalicSynthesizer?,
        defaultFont: CTFont,
        attributedStringBridge: ERTAttributedStringBridge
    ) -> NSMutableAttributedString {
        var attributedString = richText.attributedString(defaultFont: defaultFont)
        if let italicSynthesizer {
            attributedString = italicSynthesizer.synthesize(attributedString)
        }
        return .init(attributedString: attributedStringBridge.nsAttributedString(for: attributedString))
    }

    public init(richText: RichText, defaultFont: CTFont, italicSynthesizer: ERTItalicSynthesizer? = nil, attributedStringBridge: ERTAttributedStringBridge = .default, fontUtils: ERTFontUtils = .default) {
        self.richText = richText
        self.defaultFont = defaultFont
        self.italicSynthesizer = italicSynthesizer
        self.attributedStringBridge = attributedStringBridge
        self.fontUtils = fontUtils

        self.nsAttributedString = Self.nsAttributedString(
            from: richText,
            italicSynthesizer: italicSynthesizer,
            defaultFont: defaultFont,
            attributedStringBridge: attributedStringBridge
        )
    }

    func updateSelectedRange(_ range: NSRange?) {
        Task { @MainActor in
            selectedRange = range
        }
    }

    func endEditing() {
        print("ERTRichTextEditContext triggerRichTextUpdate")
        Task { @MainActor in
            richText = .init(attributedString: attributedStringBridge.attributedString(for: normalizedNSAttributedString))
            onEndEditing?()
        }
    }

    private func triggerTextUpdate() {
        onTextUpdated?(nsAttributedString)
    }

    func safeCurrentRange(omitLast: Bool = false) -> NSRange {
        let length = normalizedNSAttributedString.length
        let omit = length > 0 ? 1 : 0/*omitLast ? 1 : 0*/

        let range = if let selectedRange, selectedRange.length > 0 {
            NSRange(
                location: max(0, min(length - omit, selectedRange.location)),
                length: min(selectedRange.length, max(0, length - selectedRange.location))
            )
        } else {
            NSRange(location: 0, length: length)
        }
        print("ERTRichTextEditContext safeCurrentRange range = \(range)")

        return range
    }

    public func setRichText(_ richText: RichText) {
        self.nsAttributedString = Self.nsAttributedString(
            from: richText,
            italicSynthesizer: italicSynthesizer,
            defaultFont: defaultFont,
            attributedStringBridge: attributedStringBridge
        )
    }

    public var normalizedNSAttributedString: NSAttributedString {
        if let italicSynthesizer {
            let attributedString = attributedStringBridge.attributedString(for: nsAttributedString)
            let desynthesized = italicSynthesizer.desynthesize(attributedString)
            return attributedStringBridge.nsAttributedString(for: desynthesized)
        } else {
            return nsAttributedString
        }
    }

#if canImport(AppKit)
    public var currentFont: NSFont {
        if let value = normalizedNSAttributedString.attribute(.font, at: safeCurrentRange().location, effectiveRange: nil), let font = value as? NSFont {
            font
        } else {
            defaultFont
        }
    }
#elseif canImport(UIKit)
    public var currentFont: UIFont {
        let range = safeCurrentRange()
        print("ERTRichTextEditContext currentFont range = \(range), normalizedNSAttributedString = \(normalizedNSAttributedString)")
        return if let value = normalizedNSAttributedString.attribute(.font, at: safeCurrentRange().location, effectiveRange: nil), let font = value as? UIFont {
            font
        } else {
            defaultFont
        }
    }
#endif

    // MARK: Bold, Italic, Underline
    public var isBold: Bool {
#if canImport(AppKit)
        return currentFont.fontDescriptor.symbolicTraits.contains(.bold)
#elseif canImport(UIKit)
        return currentFont.fontDescriptor.symbolicTraits.contains(.traitBold)
#endif
    }

    public var isItalic: Bool {
#if canImport(AppKit)
        return currentFont.fontDescriptor.symbolicTraits.contains(.italic)
#elseif canImport(UIKit)
        return currentFont.fontDescriptor.symbolicTraits.contains(.traitItalic)
#endif
    }

    public var isUnderlined: Bool {
        guard
            let underlineStyleNumber = normalizedNSAttributedString.attribute(.underlineStyle, at: safeCurrentRange().location, effectiveRange: nil),
            let underlineStyleNSNumber = underlineStyleNumber as? NSNumber
        else {
            return false
        }

        return underlineStyleNSNumber != 0
    }
    
    public var isStrikethrough: Bool {
        guard
            let strikethroughStyleNumber = normalizedNSAttributedString.attribute(.strikethroughStyle, at: safeCurrentRange().location, effectiveRange: nil),
            let strikethroughStyleNSNumber = strikethroughStyleNumber as? NSNumber
        else {
            return false
        }

        return strikethroughStyleNSNumber != 0
    }

    public func setBold(_ bold: Bool = true) {
        let newFont = fontUtils.font(currentFont) { traits in
#if canImport(AppKit)
            if bold {
                traits.insert(.bold)
            } else {
                traits.remove(.bold)
            }
#elseif canImport(UIKit)
            if bold {
                traits.insert(.traitBold)
            } else {
                traits.remove(.traitBold)
            }
#endif
        }
        nsAttributedString.addAttribute(.font, value: newFont, range: safeCurrentRange(omitLast: true))
        triggerTextUpdate()
    }
    public func toggleBold() {
        setBold(!isBold)
    }

    public func setItalic(_ italic: Bool = true) {
        var newFont = fontUtils.font(currentFont) { traits in
#if canImport(AppKit)
            if italic {
                traits.insert(.italic)
            } else {
                traits.remove(.italic)
            }
#elseif canImport(UIKit)
            if italic {
                traits.insert(.traitItalic)
            } else {
                traits.remove(.traitItalic)
            }
#endif
        }

        if let italicSynthesizer, italic {
            newFont = italicSynthesizer.synthesize(newFont)
        }

        let range = safeCurrentRange(omitLast: true)
        nsAttributedString.addAttribute(.font, value: newFont, range: range)
        if italicSynthesizer != nil {
            nsAttributedString.addAttribute(.ertSynthesizedItalic, value: italic, range: range)
        }
        triggerTextUpdate()
    }
    public func toggleItalic() {
        setItalic(!isItalic)
    }

    public func setUnderlined(_ underlined: Bool) {
        nsAttributedString.addAttribute(.underlineStyle, value: underlined ? NSUnderlineStyle.single.rawValue : 0, range: safeCurrentRange())
        triggerTextUpdate()
    }
    public func toggleUnderlined() {
        setUnderlined(!isUnderlined)
    }
    
    public func setStrikethrough(_ strikethrough: Bool) {
        nsAttributedString.addAttribute(.strikethroughStyle, value: strikethrough ? NSUnderlineStyle.single.rawValue : 0, range: safeCurrentRange())
        triggerTextUpdate()
    }
    public func toggleStrikethrough() {
        setStrikethrough(!isStrikethrough)
    }
    
    public func removeAllAttributes(){
        setBold(false)
        setItalic(false)
        setUnderlined(false)
        setStrikethrough(false)
        setColor(nil)
        setBackgroundColor(nil)
    }
    
    // MARK: Color

#if canImport(SwiftUI)
    public var currentColor: Color? {
#if canImport(UIKit)
        if let color = normalizedNSAttributedString.attribute(.foregroundColor, at: safeCurrentRange().location, effectiveRange: nil) as? UIColor {
            Color(uiColor: color)
        } else {
            nil
        }
#elseif canImport(AppKit)
        if let color = normalizedNSAttributedString.attribute(.foregroundColor, at: safeCurrentRange().location, effectiveRange: nil) as? NSColor {
            Color(nsColor: color)
        } else {
            nil
        }
#endif
    }

    public var currentBackgroundColor: Color? {
#if canImport(UIKit)
        if let color = normalizedNSAttributedString.attribute(.backgroundColor, at: safeCurrentRange().location, effectiveRange: nil) as? UIColor {
            Color(uiColor: color)
        } else {
            nil
        }
#elseif canImport(AppKit)
        if let color = normalizedNSAttributedString.attribute(.backgroundColor, at: safeCurrentRange().location, effectiveRange: nil) as? NSColor {
            Color(nsColor: color)
        } else {
            nil
        }
#endif
    }

    public func setColor(_ color: Color?) {
        if let color {
#if canImport(UIKit)
            nsAttributedString.addAttribute(.foregroundColor, value: UIColor(color), range: safeCurrentRange())
#elseif canImport(AppKit)
            nsAttributedString.addAttribute(.foregroundColor, value: NSColor(color), range: safeCurrentRange())
#endif
        } else {
            nsAttributedString.removeAttribute(.foregroundColor, range: safeCurrentRange())
        }
        triggerTextUpdate()
    }

    public func setBackgroundColor(_ color: Color?) {
        if let color {
#if canImport(UIKit)
            nsAttributedString.addAttribute(.backgroundColor, value: UIColor(color), range: safeCurrentRange())
#elseif canImport(AppKit)
            nsAttributedString.addAttribute(.backgroundColor, value: NSColor(color), range: safeCurrentRange())
#endif
        } else {
            nsAttributedString.removeAttribute(.backgroundColor, range: safeCurrentRange())
        }
        triggerTextUpdate()
    }
#endif
}
