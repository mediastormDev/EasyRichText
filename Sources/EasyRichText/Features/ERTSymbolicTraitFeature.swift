//
//  ERTSymbolicTraitFeature.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/30.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
public protocol ERTSymbolicTraitFeature: ERTSingleKeyFeature where Key == AttributeScopes.AppKitAttributes.FontAttribute, Value == Bool {
    static var traits: NSFontDescriptor.SymbolicTraits { get }

    var isOn: Bool { get set }

    init(value: Bool?)
}
#elseif canImport(UIKit)
public protocol ERTSymbolicTraitFeature: ERTSingleKeyFeature where Key == AttributeScopes.UIKitAttributes.FontAttribute, Value == Bool {
    static var traits: UIFontDescriptor.SymbolicTraits { get }

    var isOn: Bool { get set }

    init(value: Bool?)
}
#endif


#if canImport(AppKit)
public extension ERTSymbolicTraitFeature {
    init(attributeKeyValue: NSFont?) {
        if let attributeKeyValue {
            self.init(value: attributeKeyValue.fontDescriptor.symbolicTraits.contains(Self.traits))
        } else {
            self.init(value: nil)
        }
    }

    func transformAttributedKeyValue(_ attributedKeyValue: NSFont?) -> NSFont? {
        let font = attributedKeyValue ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        var traits = font.fontDescriptor.symbolicTraits
        if isOn {
            traits.insert(Self.traits)
        } else {
            traits.remove(Self.traits)
        }
        let newDescriptor = font.fontDescriptor.withSymbolicTraits(traits)
        return .init(descriptor: newDescriptor, size: font.pointSize)
    }
}
#endif

#if canImport(UIKit)
public extension ERTSymbolicTraitFeature {
    init(attributeKeyValue: UIFont?) {
        if let attributeKeyValue {
            self.init(value: attributeKeyValue.fontDescriptor.symbolicTraits.contains(Self.traits))
        } else {
            self.init(value: nil)
        }
    }

    func transformAttributedKeyValue(_ attributedKeyValue: UIFont?) -> UIFont? {
        let font = attributedKeyValue ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        var traits = font.fontDescriptor.symbolicTraits
        if isOn {
            traits.insert(Self.traits)
        } else {
            traits.remove(Self.traits)
        }
        let newDescriptor = font.fontDescriptor.withSymbolicTraits(traits) ?? font.fontDescriptor
        return .init(descriptor: newDescriptor, size: font.pointSize)
    }
}
#endif

