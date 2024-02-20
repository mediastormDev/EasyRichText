//
//  ERTSingleKeyFeature.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/30.
//

import Foundation

public protocol ERTSingleKeyFeature: ERTFeature {
    associatedtype Key: AttributedStringKey
    associatedtype Value: Codable, Hashable, Equatable

    init(attributeKeyValue: Key.Value?)
    init(value: Value?)

    func transformAttributedKeyValue(_ attributedKeyValue: Key.Value?) -> Key.Value?
}

public extension ERTSingleKeyFeature {
    init?(attributeContainer: AttributeContainer) {
        self.init(attributeKeyValue: attributeContainer[Key.self])
    }

    func setupAttributes(on attributedString: AttributedString) -> AttributedString {
        var attributedString = attributedString
        let keyValue = attributedString[Key.self]
        attributedString[Key.self] = transformAttributedKeyValue(keyValue)
        return attributedString
    }
}
