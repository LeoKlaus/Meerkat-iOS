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
    
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var connectionProtocol: String = "https://"
    @State private var serverURL: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var isCheckingConnection: Bool = false
    
    @State private var healthStatus: HealthStatus?
    @State var apiHandler: ApiHandler? = ApiHandler()
    
    @Binding var connectionHandler: ConnectionHandler?
    
    var connectionPage: some View {
        VStack {
            HStack(spacing: 0) {
                Picker("Protocol", selection: self.$connectionProtocol) {
                    Text("https://").tag("https://")
                    Text("http://").tag("http://")
                }
                
                TextField("Server", text: self.$serverURL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.URL)
            }
            
            Button(action: self.connect) {
                if self.isCheckingConnection {
                    ProgressView()
                } else {
                    Text("Connect")
                }
            }
            .buttonStyle(.glassProminent)
            .padding()
            .disabled(self.isCheckingConnection || self.serverURL.isEmpty)
        }
    }
    
    var loginPage: some View {
        VStack {
            Spacer()
            
            TextField("Username", text: self.$username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.username)
            
            SecureField("Password", text: self.$password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.password)
            
            Button(action: self.login) {
                if self.isCheckingConnection {
                    ProgressView()
                } else {
                    Text("Connect")
                }
            }
            .buttonStyle(.glassProminent)
            .padding()
            .disabled(self.username.isEmpty || self.password.isEmpty || self.isCheckingConnection)
            
            Spacer()
            
            if let apiHandler {
                
                NavigationLink(destination: RegistrationView(apiHandler: apiHandler)) {
                    Text("Register")
                }
                .padding()
                
                NavigationLink(destination: ResetPasswordView(apiHandler: apiHandler)) {
                    Text("Forgot password?")
                }
            }
            
            VStack {
                if let serverHost = self.apiHandler?.serverURL.host() {
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
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if apiHandler != nil {
                    self.loginPage
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
        
        guard let url = URL(string: self.connectionProtocol + self.serverURL) else {
            self.errorHandler.handle("Server URL is not valid", while: "connecting to server")
            return
        }
        
        let apiHandler = ApiHandler(serverURL: url)
        
        Task {
            do {
                self.healthStatus = try await apiHandler.checkHealth()
                self.apiHandler = apiHandler
                UserDefaults.meerkat?.set(url, forKey: .userDefaults(.serverURL))
            } catch {
                self.errorHandler.handle(error, while: "connecting to server")
            }
            withAnimation {
                self.isCheckingConnection = false
            }
        }
    }
    
    
    private func login() {
        withAnimation {
            self.isCheckingConnection = true
        }
        
        guard let apiHandler else {
            self.errorHandler.handle("Missing apiHandler, this is weird.", while: "logging in")
            return
        }
        
        Task {
            do {
                let loginResponse = try await apiHandler.login(username: self.username, password: self.password)
                // TODO: Do something with this?
                print(loginResponse)
                self.connectionHandler = ConnectionHandler(apiHandler: apiHandler)
            } catch {
                self.errorHandler.handle(error, while: "logging in")
            }
            
            withAnimation {
                self.isCheckingConnection = false
            }
        }
    }
    
    private func checkServerConnection() async throws {
        guard let apiHandler else {
            return
        }
        self.healthStatus = try await apiHandler.checkHealth()
    }
    
    private func disconnect() {
        UserDefaults.meerkat?.removeObject(forKey: .userDefaults(.serverURL))
        self.apiHandler = nil
    }
}

#Preview("Connection Page") {
    LoginView(connectionHandler: .constant(nil))
        .withErrorHandling()
}

#Preview("Login Page") {
    LoginView(
        apiHandler: .mock,
        connectionHandler: .constant(nil)
    )
    .withErrorHandling()
}
