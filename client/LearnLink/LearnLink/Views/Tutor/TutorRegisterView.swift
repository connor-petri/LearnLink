//
//  TutorRegisterView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI


struct TutorRegisterView: View {
    @ObservedObject var appdata: Appdata = .shared
    @State var tutor: Tutor = .shared
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var subject: Subject? = nil
    @State private var isRegistering: Bool = false
    
    
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
                            try await tutor.register(email: email, password: password, firstName: firstName, lastName: lastName, subject: subject)
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
