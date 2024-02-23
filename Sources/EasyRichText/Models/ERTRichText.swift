//
//  ERTRichText.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/30.
//

import SwiftUI
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public protocol ERTRichText: Codable, Hashable {
    associatedtype Segment: ERTSegment

    var segments: [Segment] { get set }

    init()
    init(attributedString: AttributedString)

    func attributedString(defaultFont: CTFont) -> AttributedString
}

public extension ERTRichText {
    init(attributedString: AttributedString) {
        self.init()
        self.segments = attributedString.runs.map { run in
            let text = String(attributedString[run.range].characters)
            return .init(text: text, attributeContainer: run.attributes)
        }
    }

    init(nsAttributedString: NSAttributedString) {
        let attributedString = ERTAttributedStringBridge.default.attributedString(for: nsAttributedString)

        self.init(attributedString: attributedString)
    }

    init(string: String) {
        self.init()
        self.segments = [.init(text: string)]
    }

    func attributedString(defaultFont: CTFont) -> AttributedString {
        segments.map { $0.attributedString(defaultFont: defaultFont) }.reduce(AttributedString(), +)
    }
    func attributedString(defaultFont: Font) -> AttributedString {
        let ctFont = ERTFontUtils.default.ctFont(from: defaultFont)
        #if canImport(AppKit)
        let fallbackFont = NSFont.preferredFont(forTextStyle: .body)
        #elseif canImport(UIKit)
        let fallbackFont = UIFont.preferredFont(forTextStyle: .body)
        #endif
        return attributedString(defaultFont: ctFont ?? fallbackFont)
    }

    func nsAttributedString(defaultFont: CTFont) -> NSAttributedString {
        ERTAttributedStringBridge.default.nsAttributedString(for: attributedString(defaultFont: defaultFont))
    }

    var plainText: String {
        segments.map { $0.text }.joined()
    }
}
