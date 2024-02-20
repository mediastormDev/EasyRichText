//
//  ERTUnderlineFeature.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/2/19.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct ERTUnderlineFeature: ERTSingleKeyFeature {
    #if canImport(AppKit)
    public typealias Key = AttributeScopes.AppKitAttributes.UnderlineStyleAttribute
    #elseif canImport(UIKit)
    public typealias Key = AttributeScopes.UIKitAttributes.UnderlineStyleAttribute
    #endif

    public var value: Bool

    public init(value: Bool?) {
        self.value = value ?? false
    }

    public init(attributeKeyValue: NSUnderlineStyle?) {
        self.value = if let attributeKeyValue { !attributeKeyValue.isEmpty } else { false }
    }

    public func transformAttributedKeyValue(_ attributedKeyValue: NSUnderlineStyle?) -> NSUnderlineStyle? {
        if value { .single } else { [] }
    }
}
