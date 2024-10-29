//
//  Customer.swift
//  LearnLink
//
//  Created by Connor Petri on 10/26/24.
//

import Foundation
import SwiftUI


struct CustomerRegisterRequest: Encodable {
    let email: String
    let password: String
    let first_name: String
    let last_name: String
    
    init(_ email: String, _ password: String, _ firstName: String, _ lastName: String) {
        self.email = email
        self.password = password
        self.first_name = firstName
        self.last_name = lastName
    }
}


struct CustomerLoginResponse: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
}


class Customer {
    static var shared: Customer = Customer()
    
    let session: URLSession = .shared
    
    var isLoggedIn: Bool = false
    
    var id: Int = -1
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var students: [Student] = []
    
    
    func register(_ email: String, _ password: String, _ firstName: String, _ lastName: String) async throws -> Void {
        let url = URL(string: Appdata.shared.serverURL + "/customer/register")
        let session = self.session
        
        do {
            let jsonData = try JSONEncoder().encode(CustomerRegisterRequest(email, password, firstName, lastName))
            
            var request = URLRequest(url: url!)
            request.httpMethod = "PUT"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        print("Successfully registered")
                        Appdata.shared.path.removeLast()
                    } else {
                        print("Error: status code \(httpResponse.statusCode)")
                    }
                }
            }
            
            uploadTask.resume()
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    func login(email: String, password: String) async throws -> Void {
        let url = URL(string: Appdata.shared.serverURL + "/customer/login")!
        
        do {
            let loginData = ["email": email,
                    "password": password]
            
            let jsonData = try JSONEncoder().encode(loginData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = self.session.uploadTask(with: request, from: jsonData) { (data, response, error) in
                do {
                    if let error {
                        print("Error: \(error)")
                        return
                    }
                
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("Logged in customer with email: " + (loginData["email"]!))
                            let data: CustomerLoginResponse = try JSONDecoder().decode(CustomerLoginResponse.self, from: data!)
                            self.id = data.id
                            self.email = data.email
                            self.firstName = data.first_name
                            self.lastName = data.last_name
                            
                            self.isLoggedIn = true
                            
                            Appdata.shared.path.append("CustomerMainView")
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            uploadTask.resume()
            _ = try await self.getStudents()
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    func getStudents() async throws -> [Student]? {
        if !self.isLoggedIn {
            return nil
        }
        
        do {
            let url = URL(string: Appdata.shared.serverURL + "/customer/get_students")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = self.session.dataTask(with: request) { (data, response, error) in
                    if let error {
                    print("Error: \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        guard let data else { return }
                        do {
                            let students = try JSONDecoder().decode([Student].self, from: data)
                            self.students = students
                        } catch {
                            print("Error: \(error)")
                            return
                        }
                    }
                }
            }
            
            dataTask.resume()
            return self.students
        }
    }
    
    
    func addStudent(_ firstName: String, _ lastName: String, _ dateOfBirth: Date, _ healthInformation: String) async throws -> Void {
        if !self.isLoggedIn {
            return
        }
        
        do {
            let url = URL(string: Appdata.shared.serverURL + "/customer/add_student")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let jsonData = try JSONEncoder().encode(Student(firstName, lastName, dateOfBirth, healthInformation))
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = self.session.uploadTask(with: request, from: jsonData) { (data, response, error) in
                if let error {
                    print("Error: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        print("Added student " + firstName + " " + lastName + " to customer " + self.email)
                        Appdata.shared.path.removeLast()
                    }
                }
            }
            
            uploadTask.resume()
            _ = try await self.getStudents()
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    func removeStudent(id: Int) -> Void {
        if !self.isLoggedIn {
            return
        }
        
        do {
            var request = URLRequest(url: URL(string: Appdata.shared.serverURL + "/customer/remove_student/")!)
            request.httpMethod = "DELETE"
            let jsonData = try JSONEncoder().encode(["id": id])
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = self.session.uploadTask(with: request, from: jsonData) { (data, response, error) in
                if let error {
                    print("Error uploading: \(error)")
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        print("Student removed")
                    } else {
                        print("Error removing student: \(response.statusCode)")
                    }
                }
            }
            
            uploadTask.resume()
            
        } catch {
            print("Error: \(error)")
        }
    }
}
