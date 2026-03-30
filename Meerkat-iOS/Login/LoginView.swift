//
//  LoginView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import SwiftUI
import MeerkatAPI

struct LoginView: View {
    
    @State private var connectionProtocol: String = "https://"
    @State private var serverURL: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Binding var connectionHandler: ConnectionHandler?
    
    @State private var isLoggingIn: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Picker("Protocol", selection: self.$connectionProtocol) {
                    Text("https://").tag("https://")
                    Text("http://").tag("http://")
                }
                
                TextField("Server", text: self.$serverURL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.URL)
            }
            
            TextField("Username", text: self.$username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.username)
            
            SecureField("Password", text: self.$password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.password)
            
            Button(action: self.login) {
                if self.isLoggingIn {
                    ProgressView()
                } else {
                    Text("Connect")
                }
            }
            
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    private func login() {
        guard let url = URL(string: self.serverURL) else {
            print("Invalid url")
            return
        }
        
        let apiHandler = ApiHandler(serverURL: url)
        
        Task {
            let loginResponse = try await apiHandler.login(username: self.username, password: self.password)
            // TODO: Do something with this?
            print(loginResponse)
            self.connectionHandler = ConnectionHandler(apiHandler: apiHandler)
        }
    }
}

#Preview {
    LoginView(connectionHandler: .constant(nil))
}
