//
//  CustomerAddStudentView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/28/24.
//

import SwiftUI

struct CustomerAddStudentView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var dateOfBirth: Date = .init()
    @State var healthInformation: String = ""
    @State var isAdding: Bool = false
    
    var body: some View {
        HStack {
            Text("Add Student")
                .font(.title)
                .fontWeight(.bold)
        }
        
        Form {
            Section {
                TextField("First Name *", text: $firstName)
                    .autocorrectionDisabled()
                TextField("Last Name *", text: $lastName)
                    .autocorrectionDisabled()
                DatePicker("Date of Birth",
                           selection: $dateOfBirth,
                           in: Date.distantPast...Date.now,
                           displayedComponents: .date)
                TextField("Health Information", text: $healthInformation, axis: .vertical)
            }
            
            Button("Add Student", action: {
                isAdding = true
                Task {
                    try await Customer.shared.addStudent(firstName, lastName, dateOfBirth, healthInformation)
                    isAdding = false
                }
            })
            .disabled(isAdding || firstName.isEmpty || lastName.isEmpty)
        }
    }
}

#Preview {
    CustomerAddStudentView()
}
