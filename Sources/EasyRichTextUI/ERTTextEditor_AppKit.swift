//
//  ERTTextEditor_AppKit.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/2/2.
//

#if canImport(AppKit)
import SwiftUI
import AppKit
import EasyRichText

struct ERTTextEditor<RichText: ERTRichText>: NSViewRepresentable {
    @ObservedObject var editContext: ERTRichTextEditContext<RichText>
    var customize: ((NSTextView) -> ())?

    init(editContext: ERTRichTextEditContext<RichText>, customize: ((NSTextView) -> ())? = nil) {
        self.editContext = editContext
        self.customize = customize
    }

    func makeCoordinator() -> ERTTextViewDelegate<RichText> {
        .init(context: editContext)
    }

    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()

        textView.typingAttributes[.font] = editContext.defaultFont
        textView.backgroundColor = .clear
        textView.isRichText = true

        context.coordinator.textView = textView

        editContext.onTextUpdated = { newText in
            let selection = textView.selectedRange()
            textView.textStorage?.setAttributedString(newText)
            textView.textStorage?.edited(.editedAttributes, range: selection, changeInLength: 0)
            textView.textStorage?.processEditing()
            print("ERTTextEditor editContext onTextUpdated text = \(String(describing: textView.textStorage))")
            textView.setSelectedRange(selection)
        }

        textView.textStorage?.setAttributedString(editContext.nsAttributedString)
        textView.delegate = context.coordinator

        customize?(textView)

        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {

    }
}
#endif
