//
//  ERTBackgroundColorFeature.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/30.
//

import SwiftUI

public struct ERTBackgroundColorFeature<Value: ERTColor>: ERTSingleKeyFeature {
    public typealias Key = AttributeScopes.SwiftUIAttributes.BackgroundColorAttribute

    public var value: Value?

    public init(value: Value?) {
        self.value = value
    }

    public init(attributeKeyValue: Color?) {
        value = if let attributeKeyValue { .init(swiftUIColor: attributeKeyValue) } else { nil }
    }

    public func transformAttributedKeyValue(_ attributedKeyValue: Color?) -> Color? {
        value?.swiftUIColor
    }
}
