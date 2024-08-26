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

// https://gonzalezreal.github.io/2020/01/31/rendering-attributed-strings-in-swiftui.html
final class TextView: UITextView {
    var maxLayoutWidth: CGFloat = 0 {
        didSet {
            guard maxLayoutWidth != oldValue else { return }
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        guard maxLayoutWidth > 0 else {
            return super.intrinsicContentSize
        }

        return sizeThatFits(
            CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude)
        )
    }
}

private struct ERTTextEditorRaw<RichText: ERTRichText>: UIViewRepresentable {
    @ObservedObject public var editContext: ERTRichTextEditContext<RichText>
    var customize: ((UITextView) -> ())?
    var maxLayoutWidth: CGFloat

    init(editContext: ERTRichTextEditContext<RichText>, customize: ((UITextView) -> ())? = nil, maxLayoutWidth: CGFloat) {
        self.editContext = editContext
        self.customize = customize
        self.maxLayoutWidth = maxLayoutWidth
    }

    func makeCoordinator() -> ERTTextViewDelegate<RichText> {
        .init(context: editContext)
    }

    func makeUIView(context: Context) -> TextView {
        let textView = TextView()

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

        customize?(textView)

        textView.maxLayoutWidth = maxLayoutWidth

        return textView
    }

    func updateUIView(_ uiView: TextView, context: Context) {
        uiView.maxLayoutWidth = maxLayoutWidth
        uiView.invalidateIntrinsicContentSize()
        uiView.layoutIfNeeded()
    }
}

public struct ERTTextEditor<RichText: ERTRichText>: View {
    @ObservedObject public var editContext: ERTRichTextEditContext<RichText>
    var customize: ((UITextView) -> ())?

    public init(editContext: ERTRichTextEditContext<RichText>, customize: ((UITextView) -> ())? = nil) {
        self.editContext = editContext
        self.customize = customize
    }

    public var body: some View {
        GeometryReader { geometry in
            ERTTextEditorRaw(
                editContext: editContext,
                customize: customize,
                maxLayoutWidth: geometry.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing
            )
        }
    }
}
#endif
