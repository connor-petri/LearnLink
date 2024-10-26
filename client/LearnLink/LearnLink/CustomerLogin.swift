//
//  CustomerLogin.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI

struct CustomerLogin: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLoggingIn: Bool = false
    
    
    private func login() async throws {
        let url = URL(string: Appdata.shared.serverURL + "/customer/login")!
        let session = URLSession.shared
        
        do {
            let loginData = ["email": email,
                    "password": password]
            
            let jsonData = try JSONEncoder().encode(loginData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
                if let error {
                    print("Error: \(error)")
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Logged in customer with email: \(loginData["email"]!)")
                    }
                }
            }
            
            uploadTask.resume()
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("LearnLink")
                    .font(.title)
            }
            
            Form {
                Section {
                    TextField("Email", text: $email)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                }
                
                Button(action: {
                    isLoggingIn = true
                    Task {
                        try await login()
                        isLoggingIn = false
                    }
                }) {
                    Text("Login")
                }
            }
        }
    }
}

#Preview {
    CustomerLogin()
}
