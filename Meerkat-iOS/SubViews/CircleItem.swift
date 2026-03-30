//
//  CircleItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI

struct CircleItem: View {
    
    let circle: String
    
    var body: some View {
        Text(circle)
            .padding(.horizontal, 10)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(Color.gray)
            )
    }
}

#Preview {
    CircleItem(circle: "Family")
}
