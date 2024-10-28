//
//  TutorMainView.swift
//  LearnLink
//
//  Created by Connor Petri on 10/26/24.
//

import SwiftUI

struct TutorMainView: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "square.grid.2x2") { }
            
            Tab("Appointments", systemImage: "calendar") { }
            
            Tab("Account", systemImage: "person.circle") {
                TutorAccountView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TutorMainView()
}
