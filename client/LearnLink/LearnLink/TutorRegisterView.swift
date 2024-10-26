//
//  TutorRegisterView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI


struct TutorRegisterRequest: Encodable {
    let email: String
    let password: String
    let first_name: String
    let last_name: String
    let subject: String
    
    init(_ email: String, _ password: String, _ firstName: String, _ lastName: String, _ subject: String) {
        self.email = email
        self.password = password
        self.first_name = firstName
        self.last_name = lastName
        self.subject = subject
    }
}


enum Subject: CaseIterable {
    case art, biology, chemistry, computer_science, english, economics, french, geography, history, literature, mandarin, math, music, physics, philosophy, political_science, psychology, science, sociology, spanish
}


struct TutorRegisterView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var subject: Subject? = nil
    
    @State private var isRegistering: Bool = false
    
    
    private func register() async throws {
        let url = URL(string: Appdata.shared.serverURL + "/tutor/register")
        let session = URLSession.shared
        
        do {
            let jsonData = try JSONEncoder().encode(TutorRegisterRequest(email, password, firstName, lastName, String(describing: subject)))
            
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
            HStack {
                Text("Tutor Registration")
                    .font(.title)
            }
            
            Form {
                Section {
                    TextField("First Name *", text: $firstName)
                    TextField("Last Name *", text: $lastName)
                    TextField("Email *", text: $email)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                
                Section {
                    Picker("Primary Subject", selection: $subject) {
                        Text("Art").tag(Subject.art)
                        Text("Biology").tag(Subject.biology)
                        Text("Chemistry").tag(Subject.chemistry)
                        Text("Computer Science").tag(Subject.computer_science)
                        Text("English").tag(Subject.english)
                        Text("Economics").tag(Subject.economics)
                        Text("French").tag(Subject.french)
                        Text("Geography").tag(Subject.geography)
                        Text("History").tag(Subject.history)
                        Text("Literature").tag(Subject.literature)
                        Text("Mandarin").tag(Subject.mandarin)
                        Text("Math").tag(Subject.math)
                        Text("Music").tag(Subject.music)
                        Text("Physics").tag(Subject.physics)
                        Text("Philosophy").tag(Subject.philosophy)
                        Text("Political Science").tag(Subject.political_science)
                        Text("Psychology").tag(Subject.psychology)
                        Text("Science").tag(Subject.science)
                        Text("Sociology").tag(Subject.sociology)
                        Text("Spanish").tag(Subject.spanish)
                    }
                }
                
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
                .disabled(isRegistering || firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || subject == nil || password != confirmPassword)
            }
        }
    }
}

#Preview {
    TutorRegisterView()
}
