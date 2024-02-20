//
//  ERTTextViewDelegate_AppKit.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/2/2.
//

#if canImport(AppKit)

import AppKit
import EasyRichText

public class ERTTextViewDelegate<RichText: ERTRichText>: NSObject, NSTextViewDelegate {
    var context: ERTRichTextEditContext<RichText>
    weak var textView: NSTextView?

    init(context: ERTRichTextEditContext<RichText>) {
        self.context = context
    }

    public func textViewDidChangeSelection(_ notification: Notification) {
        if let selectedTextRange = textView?.selectedRange() {
            context.updateSelectedRange(selectedTextRange)
        } else {
            context.updateSelectedRange(nil)
        }
    }

    public func textDidEndEditing(_ notification: Notification) {
        context.triggerRichTextUpdate()
    }

    public func textDidChange(_ notification: Notification) {
        print("ERTTextViewDelegate textDidChange textView = \(String(describing: textView))")
        if let attributedText = textView?.attributedString() {
            print("ERTTextViewDelegate textViewDidChange attributedText = \(attributedText)")
            context.nsAttributedString = NSMutableAttributedString(attributedString: attributedText)
        }
    }
}

#endif
