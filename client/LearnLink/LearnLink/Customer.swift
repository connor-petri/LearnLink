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
    
    
    func register(_ email: String, _ password: String, _ firstName: String, _ lastName: String) async throws {
        let url = URL(string: Appdata.shared.serverURL + "/customer/register")
        let session = self.session
        
        do {
            let jsonData = try JSONEncoder().encode(CustomerRegisterRequest(email, password, firstName, lastName))
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
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
    
    
    func login(email: String, password: String) async throws {
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
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    func logout() async {
        if !self.isLoggedIn {
            return
        }
        
        let url = URL(string: Appdata.shared.serverURL + "/customer/logout")
        let request = URLRequest(url: url!)
        let uploadTask = URLSession.shared.uploadTask(with: request, from: nil) { (data, response, error) in
            if let error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Logout successful")
                    self.isLoggedIn = false
                    self.id = -1
                    self.email = ""
                    self.firstName = ""
                    self.lastName = ""
                }
            }
        }
        
        uploadTask.resume()
    }
}
