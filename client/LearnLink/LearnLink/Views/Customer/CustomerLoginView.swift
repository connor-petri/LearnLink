//
//  CustomerLogin.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI

struct CustomerLoginView: View {
    @ObservedObject var appdata: Appdata = .shared
    @State var customer: Customer = .shared
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false
    
    
    var body: some View {
        
        NavigationStack(path: $appdata.path) {
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
                            try await customer.login(email: email, password: password)
                            try await Task.sleep(for: .seconds(0.5))
                            isLoggingIn = false
                            print(customer.id)
                        }
                    }) {
                        Text("Login")
                    }
                    .disabled(isLoggingIn || email.isEmpty || password.isEmpty)
                    
                    Section {
                        Button(action: { appdata.path.append("CustomerRegisterView")}) {
                            Text("Customer Registration")
                        }
                    }
                    
                    Section {
                        Button(action: { appdata.path.append("TutorLoginView") }) {
                            Text("Tutor Login")
                        }
                    }
                }
            }
            .navigationDestination(for: String.self) { view in
                switch view {
                case "CustomerMainView":
                    CustomerMainView()
                case "CustomerRegisterView":
                    CustomerRegisterView()
                case "CustomerLoginView":
                    CustomerLoginView()
                case "CustomerAddStudentView":
                    CustomerAddStudentView()
                case "TutorLoginView":
                    TutorLoginView()
                case "TutorRegisterView":
                    TutorRegisterView()
                case "TutorMainView":
                    TutorMainView()
                default:
                    CustomerLoginView()
                }
            }
        }
    }
}

#Preview {
    CustomerLoginView()
        .environmentObject(Appdata.shared)
}
