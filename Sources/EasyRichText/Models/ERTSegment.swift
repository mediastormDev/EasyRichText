//
//  ERTSegment.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/29.
//

import Foundation
import CoreText

public protocol ERTSegment: Codable, Hashable {
    var text: String { get set }

    init(text: String, attributeContainer: AttributeContainer)
    func attributedString(defaultFont: CTFont) -> AttributedString
}

public protocol ERTForegroundColorSegment: Codable, Hashable {
    associatedtype ForegroundColor: ERTColor

    var color: ERTForegroundColorFeature<ForegroundColor>? { get set }
}

public protocol ERTBackgroundColorSegment: Codable, Hashable {
    associatedtype BackgroundColor: ERTColor

    var backgroundColor: ERTBackgroundColorFeature<BackgroundColor>? { get set }
}
