//
//  MultiLineTextField.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 07.04.26.
//

import SwiftUI

struct MultiLineTextField: View {
    
    let titleKey: LocalizedStringKey
    @Binding var text: String
    
    @FocusState private var isTextFieldFocused
    
    init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
        self.titleKey = titleKey
        self._text = text
    }
    
    var body: some View {
        TextField(self.titleKey, text: self.$text, axis: .vertical)
            .onSubmit {
                self.text.append("\n")
                self.isTextFieldFocused = true
            }
            .textInputAutocapitalization(.sentences)
            .focused(self.$isTextFieldFocused)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        self.isTextFieldFocused = false
                    }
                }
            }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    
    MultiLineTextField("Message", text: $text)
        .padding()
}
