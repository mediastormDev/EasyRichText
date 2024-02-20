//
//  ERTColor.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/30.
//

import SwiftUI

public protocol ERTColor: Codable, Hashable, Equatable {
    init(swiftUIColor: Color)
    init()

    var swiftUIColor: Color { get }
}

public protocol ERTDefinedColor: ERTColor, CaseIterable {}

public extension ERTDefinedColor {
    @available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 1.0, tvOS 17.0, *)
    private func resolvedColorIsEqual(_ c0: Color.Resolved, _ c1: Color.Resolved) -> Bool {
        let allowance: Float = 1 / (16 * 16)
        return abs(c0.red - c1.red) < allowance
            && abs(c0.green - c1.green) < allowance
            && abs(c0.blue - c1.blue) < allowance
            && abs(c0.opacity - c1.opacity) < allowance
    }

    private func cgColorIsEqual(_ c0: CGColor, _ c1: CGColor) -> Bool {
        guard let components0 = c0.components, let components1 = c1.components else { return false }
        let allowance: CGFloat = 1 / (16 * 16)
        return c0.numberOfComponents == c1.numberOfComponents
            && zip(components0, components1).allSatisfy { abs($0 - $1) < allowance }
    }

    private func resolveToCGColor(_ color: Color) -> CGColor {
#if canImport(UIKit)
        let uiColor = UIColor(color)
        return uiColor.resolvedColor(with: .init()).cgColor
#elseif canImport(AppKit)
        let nsColor = NSColor(color)
        return nsColor.cgColor
#endif
    }

    init(swiftUIColor: Color) {
        self.init()
        if #available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 1.0, tvOS 17.0, *) {
            let env = EnvironmentValues()
            let resolvedTarget = swiftUIColor.resolve(in: env)
            self = Self.allCases.first { resolvedColorIsEqual($0.swiftUIColor.resolve(in: env), resolvedTarget) } ?? .init()
        } else {
            let target = resolveToCGColor(swiftUIColor)
            self = Self.allCases.first { cgColorIsEqual(resolveToCGColor($0.swiftUIColor), target) } ?? .init()
        }
    }
}
