//
//  CustomerRegisterView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI


struct CustomerRegisterRequest: Encodable {
    let email: String
    let password: String
    let first_name: String
    let last_name: String
    
    init(_ email: String, _ password: String, _ firstName: String, _ lastName: String) {
        self.email = email
        self.password = password
        self.first_name = firstName
        self.last_name = lastName
    }
}


struct CustomerRegisterResponse: Decodable {
    let message: String
    let account_type: String
}


struct CustomerRegisterView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isRegistering: Bool = false
    
    
    private func register() async throws {
        let url = URL(string: Appdata.shared.serverURL + "/customer/register")
        let session = URLSession.shared
        
        do {
            let jsonData = try JSONEncoder().encode(CustomerRegisterRequest(email, password, firstName, lastName))
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        print("Successfully registered")
                    } else {
                        print("Error: status code \(httpResponse.statusCode)")
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
            Form {
                TextField("First Name *", text: $firstName)
                TextField("Last Name *", text: $lastName)
                TextField("Email *", text: $email)
                SecureField("Password *", text: $password)
                SecureField("Confirm Password *", text: $confirmPassword)
                
                Button(
                    action: {
                        isRegistering = true
                        Task {
                            try await register()
                            isRegistering = false
                        }
                    }
                ) {
                    Text("Register")
                }
                .disabled(password != confirmPassword || password.isEmpty || email.isEmpty || firstName.isEmpty || lastName.isEmpty || isRegistering)
            }
        }
    }
}

#Preview {
    CustomerRegisterView()
}
