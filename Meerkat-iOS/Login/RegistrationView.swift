//
//  RegistrationView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling
import MeerkatAPI

struct RegistrationView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let serverURL: URL
    
    @State private var username: String = ""
    @State private var mailAddress: String = ""
    @State private var password: String = ""
    @State private var language: InterfaceLanguage = .en
    
    @State private var isWaitingForRegistration: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(.meerkatLogo)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
                .padding()
            
            TextField("Username", text: self.$username)
                .textInputAutocapitalization(.never)
                .textContentType(.username)
            
            TextField("Email", text: self.$mailAddress)
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
            
            SecureField("Password", text: self.$password)
                .textContentType(.newPassword)
            
            HStack {
                Text("Language (for web only)")
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("Language (for web only)", selection: self.$language) {
                    Text("English").tag(InterfaceLanguage.en)
                    Text("German").tag(InterfaceLanguage.de)
                }
            }
            
            Button(action: self.sendRegistration) {
                if self.isWaitingForRegistration {
                    ProgressView()
                } else {
                    Text("Submit")
                }
            }
            .glassProminentButtonStyleIfAvailable()
            .padding()
            .disabled(self.username.isEmpty || self.mailAddress.isEmpty || self.password.isEmpty || self.isWaitingForRegistration)
            
            Spacer()
        }
        .padding()
        .textFieldStyle(.roundedBorder)
    }
    
    private func sendRegistration() {
        withAnimation {
            self.isWaitingForRegistration = true
        }
        Task {
            do {
                try await ApiHandler.register(serverURL: self.serverURL, username: self.username, password: self.password, mailAddress: self.mailAddress, language: self.language)
                self.errorHandler.showInfo("Registration complete!")
                self.dismiss()
            } catch {
                self.errorHandler.handle(error, while: "submitting registration")
            }
            withAnimation {
                self.isWaitingForRegistration = false
            }
        }
    }
}

#Preview {
    RegistrationView(serverURL: URL(string: "https://meerkat-crm-demo.fly.dev")!)
        .withErrorHandling()
}
