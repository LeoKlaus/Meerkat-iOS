//
//  LoginView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling
import MeerkatAPI

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var connectionProtocol: String = "https://"
    @State private var serverURLString: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var isCheckingConnection: Bool = false
    
    @State private var healthStatus: HealthStatus?
    
    @State var serverURL: URL?
    
    @Binding var connectionHandler: ConnectionHandler?
    
    var isInitialSetup: Bool = true
    
    var connectionPage: some View {
        VStack {
            
            Image(.meerkatLogo)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
                .padding()
            
            HStack(spacing: 0) {
                Picker("Protocol", selection: self.$connectionProtocol) {
                    Text("https://").tag("https://")
                    Text("http://").tag("http://")
                }
                
                TextField("Server", text: self.$serverURLString)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.URL)
                    .onSubmit(self.connect)
            }
            
            Button(action: self.connect) {
                if self.isCheckingConnection {
                    ProgressView()
                } else {
                    Text("Connect")
                }
            }
            .glassProminentButtonStyleIfAvailable()
            .padding()
            .disabled(self.isCheckingConnection || self.serverURLString.isEmpty)
        }
    }
    
    @ViewBuilder
    func loginPage(serverURL: URL) -> some View {
        VStack {
            Spacer()
            
            Image(.meerkatLogo)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
                .padding()
            
            TextField("Username", text: self.$username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.username)
            
            SecureField("Password", text: self.$password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.password)
                .onSubmit {
                    self.login(serverURL: serverURL)
                }
            
            Button {
                self.login(serverURL: serverURL)
            } label: {
                if self.isCheckingConnection {
                    ProgressView()
                } else {
                    Text("Connect")
                }
            }
            .glassProminentButtonStyleIfAvailable()
            .padding()
            .disabled(self.username.isEmpty || self.password.isEmpty || self.isCheckingConnection)
            
            Spacer()
            
            Group {
                NavigationLink(destination: RegistrationView(serverURL: serverURL)) {
                    Text("Register")
                }
                .padding()
                
                NavigationLink(destination: ResetPasswordView(serverURL: serverURL)) {
                    Text("Forgot password?")
                }
                
                VStack {
                    if let serverHost = self.serverURL?.host() {
                        Text("Connected to \(serverHost)")
                    }
                    Text("(Meerkat version \(self.healthStatus?.version ?? "unknown"))")
                    Button(action: self.disconnect) {
                        Text("Disconnect")
                            .underline()
                    }
                }
                .foregroundStyle(.secondary)
                .font(.caption)
                .padding()
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if let serverURL {
                    self.loginPage(serverURL: serverURL)
                        .throwingTask(taskDescription: "checking server connection", self.checkServerConnection)
                } else {
                    self.connectionPage
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding()
        }
    }
    
    func connect() {
        withAnimation {
            self.isCheckingConnection = true
        }
        
        guard let url = URL(string: self.connectionProtocol + self.serverURLString) else {
            self.errorHandler.handle("Server URL is not valid", while: "connecting to server")
            return
        }
        
        Task {
            do {
                self.healthStatus = try await ApiHandler.checkHealth(url)
                self.serverURL = url
            } catch {
                self.errorHandler.handle(error, while: "connecting to server")
            }
            withAnimation {
                self.isCheckingConnection = false
            }
        }
    }
    
    
    private func login(serverURL: URL) {
        withAnimation {
            self.isCheckingConnection = true
        }
        
        Task {
            do {
                let loginResponse = try await ApiHandler.login(serverURL: serverURL, username: self.username, password: self.password)
                
                // TODO: Do something with this?
                print(loginResponse)
                
                let tokenResponse = try await ApiHandler.createApiToken(serverURL: serverURL, name: "Meerkat-iOS")
                
                guard let token = tokenResponse.token else {
                    self.errorHandler.handle("Server didn't return a token", while: "logging in")
                    return
                }
                
                if self.isInitialSetup {
                    self.connectionHandler = try ConnectionHandler(serverURL: serverURL, username: self.username, token: token)
                } else {
                    let newInstance = ConnectedInstance(serverURL: serverURL, username: self.username)
                    try newInstance.save(token: token)
                    try self.connectionHandler?.switchInstance(to: newInstance)
                    self.dismiss()
                }
                
            } catch {
                self.errorHandler.handle(error, while: "logging in")
            }
        }
        
        withAnimation {
            self.isCheckingConnection = false
        }
    }
    
    private func checkServerConnection() async throws {
        guard let serverURL else {
            return
        }
        self.healthStatus = try await ApiHandler.checkHealth(serverURL)
    }
    
    private func disconnect() {
        self.serverURL = nil
    }
}

#Preview("Connection Page") {
    LoginView(connectionHandler: .constant(nil))
        .withErrorHandling()
}

#Preview("Login Page") {
    LoginView(
        serverURL: URL(string: "https://meerkat-crm-demo.fly.dev")!,
        connectionHandler: .constant(nil)
    )
    .withErrorHandling()
}
