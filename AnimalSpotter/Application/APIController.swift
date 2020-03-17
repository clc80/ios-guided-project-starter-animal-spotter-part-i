//
//  APIController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIController {
    // MARK: - Public Properties
    var bearer: Bearer?
    
    // MARK: - Private Properties
    private let baseURL = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> Void ) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the user into the data
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        // We care about the response not the data
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            // If there is an HTTP URL Response and it's not 200 error out.
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            // If everything works out
            completion(nil)
        }.resume()
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the user
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        // Make our data task request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check to see if there is an error
            guard error == nil else {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            //Decode the data
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            //If we succedded
            completion(nil)
        }.resume()
        
    }
    
    // create function for fetching all animal names
    
    // create function to fetch image
}
