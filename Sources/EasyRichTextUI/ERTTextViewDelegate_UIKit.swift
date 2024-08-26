//
//  ERTTextViewDelegate.swift
//  RichTextTest
//
//  Created by Shibo Lyu on 2024/2/1.
//

#if canImport(UIKit)

import UIKit
import EasyRichText

public class ERTTextViewDelegate<RichText: ERTRichText>: NSObject, UITextViewDelegate {
    var context: ERTRichTextEditContext<RichText>

    init(context: ERTRichTextEditContext<RichText>) {
        self.context = context
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedTextRange = textView.selectedTextRange {
            let location = textView.offset(from: textView.beginningOfDocument, to: selectedTextRange.start)
            let length = textView.offset(from: selectedTextRange.start, to: selectedTextRange.end)
            print("ERTTextViewDelegate textFieldDidChangeSelection location = \(location), length = \(length)")
            context.updateSelectedRange(NSRange(location: location, length: length))
        } else {
            context.updateSelectedRange(nil)
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        context.endEditing()
    }

    public func textViewDidChange(_ textView: UITextView) {
        print("ERTTextViewDelegate textViewDidChange textView = \(textView)")
        if let attributedText = textView.attributedText {
            print("ERTTextViewDelegate textViewDidChange attributedText = \(attributedText)")
            context.nsAttributedString = NSMutableAttributedString(attributedString: attributedText)
        }
        textView.invalidateIntrinsicContentSize()
    }
}

#endif
