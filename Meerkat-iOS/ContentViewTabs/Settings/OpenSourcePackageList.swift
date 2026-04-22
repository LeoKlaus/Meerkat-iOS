//
//  OpenSourcePackageList.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import SwiftUI

struct OpenSourcePackageListItem: View {
    let name: String
    let deveoper: String
    let url: URL?
    let license: String?
    
    @State private var showLicense: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(self.name)
                .font(.headline.monospaced())
            Text("written by \(self.deveoper)")
            HStack {
                if let url {
                    Link(destination: url) {
                        Label {
                            Text("GitHub")
                        } icon: {
                            Image(.gitHubIcon)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .buttonStyle(.bordered)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                }
                
                if license != nil {
                    Button("License", systemImage: "checkmark.seal.text.page") {
                        self.showLicense = true
                    }
                    .foregroundStyle(.primary)
                    .buttonStyle(.bordered)
                    .lineLimit(1)
                }
            }
        }
        .sheet(isPresented: self.$showLicense) {
            NavigationStack {
                VStack {
                    if let license {
                        Text(license)
                            .font(.system(size: 13).monospaced())
                    } else {
                        Text("Nothing to see here :)")
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark.circle") {
                            self.showLicense = false
                        }
                    }
                }
            }
        .presentationDetents([.medium, .large])
    }
}
}

struct OpenSourcePackageList: View {
    var body: some View {
        List {
            OpenSourcePackageListItem.swiftUIFlow
            OpenSourcePackageListItem.meerkatAPI
            
            Section("With special thanks to") {
                OpenSourcePackageListItem(name: "Meerkat CRM", deveoper: "Frederic Buchner", url: URL(string: "https://github.com/fbuchner/meerkat-crm"), license: nil)
            }
        }
    }
}


extension OpenSourcePackageListItem {
    static let swiftUIFlow = OpenSourcePackageListItem(
        name: "SwiftUI-Flow",
        deveoper: "Laszlo Teveli",
        url: URL(string: "https://github.com/tevelee/SwiftUI-Flow"),
        license: """
        MIT License
        
        Copyright (c) 2023 Laszlo Teveli
        
        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.
        
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
        """
    )
    
    static let meerkatAPI = OpenSourcePackageListItem(
        name: "Swift Meerkat API",
        deveoper: "Leo Wehrfrtz",
        url: URL(string: "https://github.com/LeoKlaus/Swift-MeerkatAPI"),
        license: """
        MIT License
        
        Copyright (c) 2026 Leo Wehrfritz
        
        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.
        
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
        """
    )
}

#Preview {
    OpenSourcePackageList()
}

