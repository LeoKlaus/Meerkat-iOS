//
//  ResetPasswordView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling
import MeerkatAPI

struct ResetPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let apiHandler: ApiHandler
    
    @State var mailAddress: String = ""
    @State private var token: String = ""
    @State private var newPassword: String = ""
    
    @State private var sentRequest: Bool = false
    @State private var sentRecently: Bool = false
    
    @State private var isRequestingReset: Bool = false
    @State private var isResettingPassword: Bool = false
    
    var body: some View {
        VStack {
            TextField("Email", text: self.$mailAddress)
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
            
            TextField("Token", text: self.$token)
                .textInputAutocapitalization(.never)
                .textContentType(.oneTimeCode)
                .disabled(!self.sentRequest)
            
            
            SecureField("New Password", text: self.$newPassword)
                .textContentType(.newPassword)
            
            Button(action: self.requestReset) {
                if self.isRequestingReset {
                    ProgressView()
                } else {
                    Text("Send reset email")
                }
            }
            .padding()
            .disabled(self.isRequestingReset || self.mailAddress.isEmpty || self.sentRecently)
            
            if self.sentRequest {
                Button(action: self.setNewPassword) {
                    if self.isResettingPassword {
                        ProgressView()
                    } else {
                        Text("Reset Password")
                    }
                }
                .buttonStyle(.glassProminent)
                .disabled(self.isResettingPassword || self.token.isEmpty || self.newPassword.isEmpty)
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    private func requestReset() {
        withAnimation {
            self.isRequestingReset = true
        }
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { _ in
            withAnimation {
                self.sentRecently = false
            }
        }
        
        Task {
            do {
                try await self.apiHandler.requestPasswordReset(mailAddress: self.mailAddress)
            } catch {
                self.errorHandler.handle(error, while: "requesting password reset")
            }
            withAnimation {
                self.isRequestingReset = false
                self.sentRequest = true
                self.sentRecently = true
            }
        }
    }
    
    private func setNewPassword() {
        withAnimation {
            self.isResettingPassword = true
        }
        
        Task {
            do {
                try await self.apiHandler.confirmPasswordReset(token: self.token, newPassword: self.newPassword)
                self.errorHandler.showInfo("Password reset!")
                self.dismiss()
            } catch {
                self.errorHandler.handle(error, while: "confirming password reset")
            }
            withAnimation {
                self.isResettingPassword = false
                self.sentRequest = true
                self.sentRecently = true
            }
        }
    }
}

#Preview {
    ResetPasswordView(apiHandler: .mock)
        .withErrorHandling()
}
