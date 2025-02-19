//
//  CustomerMainView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/26/24.
//

import SwiftUI

struct CustomerMainView: View {
    
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "square.grid.2x2") { }
            
            Tab("Appointments", systemImage: "calendar") { }
            
            Tab("Account", systemImage: "person.circle") {
                CustomerAccountView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CustomerMainView()
}
