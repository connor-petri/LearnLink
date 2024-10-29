//
//  CustomerAccountView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/27/24.
//

import SwiftUI


struct StudentsHeader: View {
    var body: some View {
        HStack {
            Text("Students")
            Spacer()
            Button(action: { Appdata.shared.path.append("CustomerAddStudentView")}) {
                Image(systemName: "plus")
            }
        }
    }
}


struct StudentGroupBoxContent: View {
    @State var student: Student
    
    init(student: Student) {
        self.student = student
    }
    
    var body: some View {
        HStack {
            Text(student.first_name + " " + student.last_name)
            Spacer()
            Button(action: {}) {
                Image(systemName: "minus")
                    .foregroundStyle(.red)
            }
        }
        
        Text("Age: \(student.date_of_birth.distance(to: Date()))")
        GroupBox(label: Text("Health Information")) {
            Text(student.health_information)
        }
    }
}


struct CustomerAccountView: View {
    @State var customer: Customer = .shared
    @State var isLoggingOut: Bool = false
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Account")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            GroupBox(label: StudentsHeader()) {
                ScrollView {
                    ForEach(customer.students) { student in
                        GroupBox() {
                            StudentGroupBoxContent(student: student)
                        }
                    }
                }
                .frame(height: 250)
            }
            .onAppear {
                Task {
                    _ = try await customer.getStudents()
                }
            }
            
            Button(action: {
                isLoggingOut = true
                Task {
                    // Log out logic here
                    isLoggingOut = false
                }
            }) {
                Text("Logout")
            }
            .disabled(isLoggingOut)
            
            Spacer()
        }
    }
}

#Preview {
    CustomerAccountView()
}
