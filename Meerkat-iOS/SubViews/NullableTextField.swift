//
//  NullableTextField.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 08.04.26.
//

import SwiftUI

struct NullableTextField: View {
    
    let titleKey: LocalizedStringKey
    @Binding var text: String?
    
    init(_ titleKey: LocalizedStringKey, text: Binding<String?>) {
        self.titleKey = titleKey
        self._text = text
    }
    
    var body: some View {
        TextField(
            self.titleKey,
            text: Binding(
                get: {
                    self.text ?? ""
                },
                set: { newValue in
                    if !newValue.isEmpty {
                        self.text = newValue
                    } else {
                        self.text = nil
                    }
                }
            )
        )
    }
}

#Preview {
    @Previewable @State var text: String? = "Test"
    
    NullableTextField("Test", text: $text)
        .padding()
}
