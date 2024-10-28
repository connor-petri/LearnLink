//
//  CustomerAccountView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/27/24.
//

import SwiftUI

struct CustomerAccountView: View {
    @State var customer: Customer = .shared
    @State var isLoggingOut: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                isLoggingOut = true
                Task {
                    await customer.logout()
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
    CustomerAccountView()
}
