//
//  ERTTextSegment.swift
//  
//
//  Created by Shibo Lyu on 2022/9/13.
//

import Foundation

/// A substring in the ``ERTRichText``.
public struct ERTTextSegment: Codable {
    /// Only basic font styles.
    public enum Style: String, Codable {
        /// `bd`
        case bold = "bd"
        /// `it`
        case italic = "it"
        /// `ul`
        case underline = "ul"
        /// `st`
        case strikethrough = "st"
        /// `ms`
        case monospace = "ms"
    }
    
    /// Colors are predefined, so they can be optimized for color schemes.
    public enum Color: String, Codable {
        /// `rd`
        case red = "rd"
        /// `yl`
        case yellow = "yl"
        /// `bl`
        case blue = "bl"
        /// `gr`
        case green = "gr"
        /// `pp`
        case purple = "pp"
        /// `pk`
        case pink = "pk"
    }
    
    /// The text in current segment.
    ///
    /// JSON key:  `t`.
    public var text: String
    /// The style modifier.
    ///
    /// JSON key: `s`.
    public var style: Set<Style>?
    /// The color of the font. `nil` for standard body color.
    ///
    /// JSON key: `c`.
    public var color: Color?
    
    enum CodingKeys: String, CodingKey {
        case text = "t"
        case style = "s"
        case color = "c"
    }
}
