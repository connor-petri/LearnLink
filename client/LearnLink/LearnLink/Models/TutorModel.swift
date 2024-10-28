//
//  Tutor.swift
//  LearnLink
//
//  Created by Connor Petri on 10/26/24.
//

import Foundation


enum Subject: CaseIterable {
    case art, biology, chemistry, computer_science, english, economics, french, geography, history, literature, mandarin, math, music, physics, philosophy, political_science, psychology, science, sociology, spanish
}


struct TutorRegisterRequest: Encodable {
    let email: String
    let password: String
    let first_name: String
    let last_name: String
    let subject: String
    
    init(_ email: String, _ password: String, _ firstName: String, _ lastName: String, _ subject: String) {
        self.email = email
        self.password = password
        self.first_name = firstName
        self.last_name = lastName
        self.subject = subject
    }
}


struct TutorLoginResponse: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
}


class Tutor {
    static let shared = Tutor()
    
    var session = URLSession.shared
    var isLoggedIn: Bool = false
    
    var id: Int = -1
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    
    func register(email: String, password: String, firstName: String, lastName: String, subject: Subject?) async throws {
        let url = URL(string: Appdata.shared.serverURL + "/tutor/register")
        
        do {
            let jsonData = try JSONEncoder().encode(TutorRegisterRequest(email, password, firstName, lastName, String(describing: subject)))
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = self.session.uploadTask(with: request, from: jsonData) { (data, response, error) in
                
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
    
    
    func login(_ email: String, _ password: String) async throws {
        let url = URL(string: Appdata.shared.serverURL + "/tutor/login")!
        
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
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("Logged in tutor with email: \(loginData["email"]!)")
                            let data: TutorLoginResponse = try JSONDecoder().decode(TutorLoginResponse.self, from: data!)
                            
                            self.id = data.id
                            self.email = data.email
                            self.firstName = data.first_name
                            self.lastName = data.last_name
                            
                            self.isLoggedIn = true
                            
                            Appdata.shared.path.append("TutorMainView")
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
        
        do {
            let url = URL(string: Appdata.shared.serverURL + "/tutor/logout")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let jsonData = try JSONEncoder().encode(["":""])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
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
                        
                        Appdata.shared.path.removeLast()
                    }
                }
            }
            
            uploadTask.resume()
        } catch {
            print("Error: \(error)")
        }
    }
}
