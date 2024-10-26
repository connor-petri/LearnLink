//
//  LearnLinkApp.swift
//  LearnLink
//
//  Created by Connor Petri on 10/25/24.
//

import SwiftUI


struct Appdata {
    static let shared = Appdata()
    
    let serverURL: String = "http://127.0.0.1:5000" // FIXME change when server is deployed.
}


@main
struct LearnLinkApp: App {
    
    var body: some Scene {
        WindowGroup {
            CustomerLogin()
        }
    }
}
