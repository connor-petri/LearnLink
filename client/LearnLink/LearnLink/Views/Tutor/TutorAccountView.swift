//
//  TutorAccountView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/27/24.
//

import SwiftUI

struct TutorAccountView: View {
    @State var tutor: Tutor = .shared
    @State var isLoggingOut: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                isLoggingOut = true
                Task {
                    // log out logic here
                    isLoggingOut = false
                }
            }) {
                Text("Logout")
            }
            .disabled(isLoggingOut)
        }
    }
}

#Preview {
    TutorAccountView()
}
