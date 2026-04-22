//
//  HelpView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import SwiftUI

struct HelpView: View {
    
    var body: some View {
        List {
            Section {
                if let ghURL = URL(string: "https://github.com/leoklaus/Meerkat-iOS/issues") {
                    Link(destination: ghURL) {
                        Label {
                            Text("Create an Issue on GitHub")
                        } icon: {
                            Image(.gitHubIcon)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .foregroundStyle(.primary)
                }
                
                SendMailButton()
            }
        }
    }
}

#Preview {
    HelpView()
}
