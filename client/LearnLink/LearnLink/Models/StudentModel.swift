//
//  StudentModel.swift
//  LearnLink
//
//  Created by Connor Petri on 10/27/24.
//

import Foundation


struct Student: Codable, Identifiable {
    let id: Int?
    let first_name: String
    let last_name: String
    let date_of_birth: Date
    let health_information: String
    
    init(_ firstName: String, _ lastName: String, _ dateOfBirth: Date, _ healthInformation: String, _ id: Int? = nil) {
        self.id = id
        self.first_name = firstName
        self.last_name = lastName
        self.date_of_birth = dateOfBirth
        self.health_information = healthInformation
    }
}
