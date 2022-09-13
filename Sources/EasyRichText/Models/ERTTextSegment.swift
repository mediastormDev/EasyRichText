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
        case bold = "bd"
        case italic = "it"
        case underline = "ul"
        case strikethrough = "st"
        case monospace = "ms"
    }
    
    /// Colors are predefined, so they can be optimized for color schemes.
    public enum Color: String, Codable {
        case red = "rd"
        case yellow = "yl"
        case blue = "bl"
        case green = "gr"
        case purple = "pp"
        case pink = "pk"
    }
    
    var text: String
    var style: Set<Style>?
    var color: Color?
    
    enum CodingKeys: String, CodingKey {
        case text = "t"
        case style = "s"
        case color = "c"
    }
}
