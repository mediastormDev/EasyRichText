//
//  ERTAttributes.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/2/2.
//

import Foundation

@_spi(Internal) public struct ERTAttributes: AttributeScope {
    @_spi(Internal) let synthesizedItalic: ERTItalicSynthesizer.SynthesizedItalicKey
}

@_spi(Internal) public extension AttributeDynamicLookup {
    subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<ERTAttributes, T>) -> T {
        return self[T.self]
    }
}
