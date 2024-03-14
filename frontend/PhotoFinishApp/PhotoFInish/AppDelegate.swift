//
//  AppDelegate.swift
//  PhotoFInish
//
//  Created by Joshua Candelaria on 3/5/24.
//

import Foundation
import UIKit
import AWSCore
import AWSLambda

class AppDelegate: NSObject, UIApplicationDelegate {

    // swiftlint: disable line_length
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupMyApp()
        return true
    }

    public func setupMyApp() {
        // TODO: Add any intialization steps here.
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USWest1,
            identityPoolId: "us-west-1:e2eea875-d7ea-4b2e-af61-f6a1121e2cfc")
        let configuration = AWSServiceConfiguration(
            region: .USWest1,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // Invoke Test Here
        /*
        let lambda = AWSLambda.default()
        let request = AWSLambdaInvocationRequest()
        request!.functionName = "login"
        request!.invocationType = .requestResponse // or .event if you don't need a response
        
        lambda.invoke(request!) { (response, error) in
            if let error = error {
                print("Error invoking Lambda function: \(error)")
            } else if let payload = response?.payload {
                // Handle the response payload here
                print("Lambda function response: \(payload)")
            }
        }

        print(credentialsProvider)
        print("Application started up!")
        */
    }
}
