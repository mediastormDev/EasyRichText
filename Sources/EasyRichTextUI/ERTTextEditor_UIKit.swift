//
//  ERTTextEditor_UIKit.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/1/31.
//

#if canImport(UIKit)
import SwiftUI
import UIKit
import EasyRichText

public struct ERTTextEditor<RichText: ERTRichText>: UIViewRepresentable {
    @ObservedObject public var editContext: ERTRichTextEditContext<RichText>

    public init(editContext: ERTRichTextEditContext<RichText>) {
        self.editContext = editContext
    }

    public func makeCoordinator() -> ERTTextViewDelegate<RichText> {
        .init(context: editContext)
    }

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        editContext.onTextUpdated = { newText in
            let selection = textView.selectedTextRange
            textView.attributedText = newText
            textView.selectedTextRange = selection
        }

        textView.attributedText = editContext.nsAttributedString
        textView.delegate = context.coordinator

        textView.typingAttributes[.font] = editContext.defaultFont
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false

        return textView
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {

    }
}
#endif
