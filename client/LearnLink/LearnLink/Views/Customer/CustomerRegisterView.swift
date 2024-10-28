//
//  CustomerRegisterView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI


struct CustomerRegisterView: View {
    @ObservedObject var appdata: Appdata = .shared
    @State var customer: Customer = .shared
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isRegistering: Bool = false
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Customer Regisration")
                    .font(.title)
            }
            Form {
                Section {
                    TextField("First Name *", text: $firstName)
                    TextField("Last Name *", text: $lastName)
                    TextField("Email *", text: $email)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    SecureField("Password *", text: $password)
                    SecureField("Confirm Password *", text: $confirmPassword)
                }
                
                Button(
                    action: {
                        isRegistering = true
                        Task {
                            try await customer.register(email, password, firstName, lastName)
                            try await Task.sleep(for: .seconds(0.1))
                            
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
        .environmentObject(Appdata.shared)
}
