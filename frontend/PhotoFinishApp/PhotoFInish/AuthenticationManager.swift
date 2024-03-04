//
//  AuthenticationManager.swift
//  PhotoFInish
//
//  Created by Joshua Candelaria on 3/4/24.
//

import AWSCognitoIdentityProvider
import AWSCognitoAuth

class AuthenticationManager {
    
    // MARK: - Properties
    
    static let sharedAuth = AuthenticationManager()
    var userPool: AWSCognitoIdentityUserPool?
    var currentUser: AWSCognitoIdentityUser?
        
    private init() {
        // Initialize Cognito user pool
        userPool = AWSCognitoIdentityUserPool(forKey: "us-west-1_eaAiwMm3i")
    }
        
    func createAccount(username: String, password: String, email: String, completion: @escaping (Error?) -> Void) {
        print("Creating new account")
        let userAttributes = [
            AWSCognitoIdentityUserAttributeType(name: "email", value: email)
        ]
        userPool?.signUp(username, password: password, userAttributes: userAttributes, validationData: nil).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                print("test")
                if let error = task.error {
                    print("Error")
                    completion(error)
                } else {
                    print("Success")
                    completion(nil)
                }
            }
            return nil
        }
    }
        
    func login(username: String, password: String, completion: @escaping (Error?) -> Void) {
        let user = userPool?.getUser(username)
        user?.getSession(username, password: password, validationData: nil).continueWith { (task) -> Any? in
            if let error = task.error {
                completion(error)
            } else if let result = task.result {
                self.currentUser = user
                completion(nil)
            }
            return nil
        }
    }
        
    func logout(completion: @escaping (Error?) -> Void) {
        currentUser?.signOut()
        currentUser = nil
        completion(nil)
    }
}
