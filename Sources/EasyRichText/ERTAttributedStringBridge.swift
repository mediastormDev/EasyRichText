//
//  ERTAttributedStringBridge.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/2/2.
//

import Foundation
import SwiftUI

@_spi(Internal) public extension NSAttributedString.Key {
    static let ertSynthesizedItalic = Self("sb.lao.packages.easyrichtext.SynthesizedItalic")
}

public struct ERTAttributedStringBridge {
    public static var `default` = ERTAttributedStringBridge()

    public var bridgeColor: Bool
    public var bridgeInternalAttributes: Bool

    public init(bridgeColor: Bool = true, bridgeInternalAttributes: Bool = true) {
        self.bridgeColor = bridgeColor
        self.bridgeInternalAttributes = bridgeInternalAttributes
    }

    public func nsAttributedString(for attributedString: AttributedString) -> NSAttributedString {
        let mutableString = NSMutableAttributedString()

        for run in attributedString.runs {
            let mutableSubstring = NSMutableAttributedString(AttributedString(attributedString[run.range]))
            let range = NSRange(location: 0, length: mutableSubstring.length)

            if bridgeInternalAttributes {
                if run.synthesizedItalic ?? false {
                    mutableSubstring.addAttribute(.ertSynthesizedItalic, value: true, range: range)
                }
            }

            if bridgeColor {
#if canImport(AppKit)
                if let color = run.attributes.swiftUI.foregroundColor {
                    mutableSubstring.addAttribute(.foregroundColor, value: NSColor(color), range: range)
                }
                if let color = run.attributes.swiftUI.backgroundColor {
                    mutableSubstring.addAttribute(.backgroundColor, value: NSColor(color), range: range)
                }
#elseif canImport(UIKit)
                if let color = run.attributes.swiftUI.foregroundColor {
                    mutableSubstring.addAttribute(.foregroundColor, value: UIColor(color), range: range)
                }
                if let color = run.attributes.swiftUI.backgroundColor {
                    mutableSubstring.addAttribute(.backgroundColor, value: UIColor(color), range: range)
                }
#endif
            }

            mutableString.append(mutableSubstring)
        }

        return mutableString
    }

    public func attributedString(for nsAttributedString: NSAttributedString) -> AttributedString {
        var attributedString = AttributedString()

        nsAttributedString.enumerateAttributes(in: .init(location: 0, length: nsAttributedString.length)) { attributes, range, _ in
            let substring = nsAttributedString.attributedSubstring(from: range)
            var attributedSubstring = AttributedString(substring)

            if bridgeInternalAttributes {
                if let synthesizedItalicValue = attributes[.ertSynthesizedItalic], let synthesizedItalic = synthesizedItalicValue as? Bool, synthesizedItalic {
                    attributedSubstring.synthesizedItalic = true
                }
            }
            attributedString += attributedSubstring
        }

        if bridgeColor {
#if canImport(AppKit)
            for run in attributedString.runs {
                if let nsColor = run.attributes.appKit.foregroundColor {
                    attributedString[run.range].swiftUI.foregroundColor = Color(nsColor: nsColor)
                }
                if let nsColor = run.attributes.appKit.backgroundColor {
                    attributedString[run.range].swiftUI.backgroundColor = Color(nsColor: nsColor)
                }
            }
#elseif canImport(UIKit)
            for run in attributedString.runs {
                if let uiColor = run.attributes.uiKit.foregroundColor {
                    attributedString[run.range].swiftUI.foregroundColor = Color(uiColor: uiColor)
                }
                if let uiColor = run.attributes.uiKit.backgroundColor {
                    attributedString[run.range].swiftUI.backgroundColor = Color(uiColor: uiColor)
                }
            }
#endif
        }

        print("ERTAttributedStringBridge attributedString: NSAttributedString: \(nsAttributedString), AttributedString: \(attributedString)")

        return attributedString
    }
}
