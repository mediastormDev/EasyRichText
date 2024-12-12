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
        let size = sizeThatFits(CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude))
        return CGSize(width: min(size.width, maxLayoutWidth), height: size.height)
    }
}

private struct ERTTextEditorRaw<RichText: ERTRichText>: UIViewRepresentable {
    @ObservedObject public var editContext: ERTRichTextEditContext<RichText>
    var customize: ((UITextView) -> ())?
    var maxLayoutWidth: CGFloat
    var alignment: NSTextAlignment

    init(editContext: ERTRichTextEditContext<RichText>, customize: ((UITextView) -> ())? = nil, maxLayoutWidth: CGFloat, alignment: NSTextAlignment = .center) {
        self.editContext = editContext
        self.customize = customize
        self.maxLayoutWidth = maxLayoutWidth
        self.alignment = alignment
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
            textView.textAlignment = alignment
        }

        textView.attributedText = editContext.nsAttributedString
        textView.delegate = context.coordinator

        textView.typingAttributes[.font] = editContext.defaultFont
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true

        customize?(textView)

        textView.maxLayoutWidth = maxLayoutWidth

        editContext.onSelectedAttributes = { attributes in
            var currentAttributes = textView.typingAttributes
            for (key, value) in attributes {
                currentAttributes[key] = value
            }
            textView.typingAttributes = currentAttributes
        }
        
        return textView
    }

    func updateUIView(_ uiView: TextView, context: Context) {
//        let fittingSize = uiView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
//
//           if fittingSize.width != uiView.maxLayoutWidth {
//               uiView.maxLayoutWidth = fittingSize.width
//               uiView.invalidateIntrinsicContentSize()
//           }
        uiView.maxLayoutWidth = maxLayoutWidth
    }
}

public struct ERTTextEditor<RichText: ERTRichText>: View {
    @ObservedObject public var editContext: ERTRichTextEditContext<RichText>
    var customize: ((UITextView) -> ())?
    
    var width: CGFloat = .zero
    
    var alignment: NSTextAlignment
    
    var showPlaceholder: Bool
    
    public init(editContext: ERTRichTextEditContext<RichText>, width: CGFloat, alignment: NSTextAlignment = .center, showPlaceholder: Bool = false, customize: ((UITextView) -> ())? = nil) {
        self.editContext = editContext
        self.customize = customize
        self.alignment = alignment
        self.width = width
        self.showPlaceholder = showPlaceholder
    }
    
    public var body: some View {
        ERTTextEditorRaw(
            editContext: editContext,
            customize: customize,
            maxLayoutWidth: width,
            alignment: alignment
        )
        .background{
            if editContext.isEmpty, showPlaceholder {
                HStack{
                    Text("无内容")
                        .font(.footnote)
                        .foregroundColor(Color.secondary)
                    Spacer()
                }
            }
        }
//        .background {
//            GeometryReader { geometry in
//                Color.clear
//                    .onAppear {
//                        self.size = geometry.size
//                    }
//                    .onChange(of: geometry.size) { newValue in
//                        self.size = newValue
//                    }
//            }
//        }
    }
}
#endif
