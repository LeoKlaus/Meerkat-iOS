//
//  AboutView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//


import SwiftUI
import EasyErrorHandling

struct AboutView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var waitingForPurchase: [String:Bool] = [:]
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("\(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS") is being developed by:")
                        .font(.headline)
                    Text("Leo Wehrfritz\nLerchenstr. 24\n55270 Zornheim\nGermany\nTel.: +49 176 32326918\nE-Mail: contact@wehrfritz.me")
                        .multilineTextAlignment(.leading)
                }
            } footer: {
                VStack(alignment: .leading) {
                    Text("\(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS") version \(appVersion ?? "") (\(build ?? "Unknown"))")
                }
            }
            
            Section {
                NavigationLink(destination: PatchNoteList()) {
                    Label("Patch Notes", systemImage: "list.bullet.clipboard")
                }
                
                NavigationLink(destination: OpenSourcePackageList()) {
                    Label("Open Source Libraries", systemImage: "shippingbox")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
