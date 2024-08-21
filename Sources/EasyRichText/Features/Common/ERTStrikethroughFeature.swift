//
//  File.swift
//
//
//  Created by Jerry Zhu on 2024/8/21.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct ERTStrikethroughFeature: ERTSingleKeyFeature {
    #if canImport(AppKit)
    public typealias Key = AttributeScopes.AppKitAttributes.StrikethroughStyleAttribute
    #elseif canImport(UIKit)
    public typealias Key = AttributeScopes.UIKitAttributes.StrikethroughStyleAttribute
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

