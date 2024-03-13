//
//  LambdaTester.swift
//  PhotoFInish
//
//  Created by Samarth Srinivasa on 3/12/24.
//

import SwiftUI
import AWSLambda
import UIKit

struct LambdaTester: View {
    @State private var s3ObjectContent: String = ""
    @State private var printedOutput = ""
    //@State private var image: UIImage? = nil


    struct RedirectedOutputStream: TextOutputStream {
                var target: LambdaTester

                mutating func write(_ string: String) {
                    target.printedOutput.append(string)
                }
            }
    var body: some View {
        VStack {
            Text("Hello from LambdaTester")
            
            Button(action: {
                callLambdaFunction()
            }) {
                Text("Call Lambda Function")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text(s3ObjectContent)
                .padding()
                .multilineTextAlignment(.center)
            Text("Please")
            

  
            AsyncImage(url: URL(string: s3ObjectContent))
                .frame(width: 678, height: 355)
            Text("Display image from URL supporting iOS 13+")
            /*
             Text("Display image from URL supporting iOS 13+")
             
             
            let url = URL(string: s3ObjectContent)?

            let data = try? Data(contentsOf: url)
            if let imageData = data {
                let image = UIImage(data: imageData)
            }
            */
           
        }
    }
    
    func callLambdaFunction() {
        let lambda = AWSLambda.default()
        let request = AWSLambdaInvocationRequest()
       
        
        request!.functionName = "getS3Object"
        request!.invocationType = .requestResponse // or .event if you don't need a response
        request!.payload = "{\"object_key\":\"test.png\"}".data(using: .utf8)
        lambda.invoke(request!) { (response, error) in
            if let error = error {
                print("Error invoking Lambda function: \(error)")
            } else if let payload = response?.payload {
                        // Handle the response payload here
                print("Lambda function response: \(payload)")
                print("Help")
                var outputStream = RedirectedOutputStream(target: self)
                print("\(payload)", to: &outputStream)
                print("Captured output: \(printedOutput)")
                //s3ObjectContent = printedOutput
                let urlString = extractURL(from: printedOutput)
                print("Extracted URL: \(urlString)")
                s3ObjectContent = urlString
                print("waht the heck")
                print("Type of s3ObjectContent: \(type(of: s3ObjectContent))")

            }
                
        }
        
        
    }
    func extractURL(from payloadString: String) -> String {
        // Extract the URL from the payload string
        if let startIndex = payloadString.range(of: "https://")?.lowerBound,
           let endIndex = payloadString.range(of: ".png")?.upperBound {
            return String(payloadString[startIndex..<endIndex])
        } else {
            return ""
        }
    }
    

}

#Preview {
    LambdaTester()
}



