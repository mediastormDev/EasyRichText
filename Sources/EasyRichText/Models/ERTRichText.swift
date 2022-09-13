//
//  ERTRichText.swift
//  
//
//  Created by Shibo Lyu on 2022/9/13.
//

import Foundation

/// The `Codable` text segment array.
///
/// ```json
/// [
///     { "t": "Hello, " },
///     { "t": "world", "s": ["st"], "c": "rd" },
///     { "t": "rich text", "s": ["bd"], "c": "gr" },
///     { "t": "!" }
/// ]
/// ```
///
/// ![Rich text sample](richtext-sample.png)
public typealias ERTRichText = [ERTTextSegment]
