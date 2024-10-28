//
//  TutorLogin.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI

struct TutorLoginView: View {
    @ObservedObject var appdata: Appdata = .shared
    @State var tutor: Tutor = .shared
    
    @State var email: String = ""
    @State var password: String = ""
    @State var isLoggingIn: Bool = false
    
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
                        try await tutor.login(email, password)
                        isLoggingIn = false
                    }
                }) {
                    Text("Login")
                }
                .disabled(isLoggingIn || email.isEmpty || password.isEmpty)
                
                Section {
                    Button(action: { appdata.path.append("TutorRegisterView") }) {
                        Text("Tutor Registration")
                    }
                }
            }
        }
    }
}

#Preview {
    TutorLoginView()
}
