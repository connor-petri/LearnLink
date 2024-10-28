//
//  LearnLinkApp.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI


class Appdata: ObservableObject {
    static let shared = Appdata()
    
    let serverURL: String = "http://127.0.0.1:5000" // FIXME change when server is deployed.
    @Published var path: NavigationPath = NavigationPath()
}


@main
struct LearnLinkApp: App {
    
    var body: some Scene {
        WindowGroup {
            CustomerLoginView()
        }
    }
}
