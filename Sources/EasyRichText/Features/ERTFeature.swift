//
//  ERTFeature.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/29.
//

import Foundation

public protocol ERTFeature: Codable, Hashable, Equatable {
    init?(attributeContainer: AttributeContainer)
    func setupAttributes(on attributedString: AttributedString) -> AttributedString
}
