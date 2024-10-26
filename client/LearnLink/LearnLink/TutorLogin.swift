//
//  TutorLogin.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI

struct TutorLogin: View {
    @State var email: String = ""
    @State var password: String = ""
    
    @State var isLoggingIn: Bool = false
    
    
    private func login() async throws {
        let url = URL(string: Appdata.shared.serverURL + "/tutor/login")!
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
                        print("Logged in tutor with email: \(loginData["email"]!)")
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
                Text("Tutor Login")
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
                .disabled(isLoggingIn || email.isEmpty || password.isEmpty)
            }
        }
    }
}

#Preview {
    TutorLogin()
}
