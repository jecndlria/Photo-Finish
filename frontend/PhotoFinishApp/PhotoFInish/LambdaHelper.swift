//
//  LambdaHelper.swift
//  PhotoFInish
//
//  Created by Samarth Srinivasa on 3/13/24.
//
/*
import SwiftUI
import AWSLambda
import UIKit

struct LambdaHelper: View {
    @State private var s3ObjectContent: String = ""
    @State var printedOutput = ""
    //@State private var image: UIImage? = nil
    var help: String = "{\"object_key\":\"test.png\"}"
    
    struct RedirectedOutputStream: TextOutputStream {
                var target: LambdaHelper

                mutating func write(_ string: String) {
                    target.printedOutput.append(string)
                }
            }
    var body: some View {
        VStack {
            Text("Hello from LambdaTester")
            
            Button(action: {
                
                //callLambdaFunction(var: help, var: "getS3Object") { printedOutput in
                    if let output = printedOutput {
                        // Use the printedOutput here
                        print("Received output: \(output)")
                    } else {
                        // Handle the case where printedOutput is nil (e.g., error handling)
                        print("Failed to receive output.")
                    }
                 
                }
           
                                
            })
{
                Text("Call Lambda Function")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            /*
            Text(s3ObjectContent)
                .padding()
                .multilineTextAlignment(.center)
            Text("Please")
            

  
            AsyncImage(url: URL(string: s3ObjectContent))
                .frame(width: 678, height: 355)
            Text("Display image from URL supporting iOS 13+")
          */
           
        }
    }
    
    func callLambdaFunction(payloadJSON: String, functionName: String) -> String?  {
        let lambda = AWSLambda.default()
        let request = AWSLambdaInvocationRequest()
        
        
        request!.functionName = functionName
        
        request!.invocationType = .requestResponse // or .event if you don't need a response
        //request!.payload = "{\"object_key\":\"test.png\"}".data(using: .utf8)
        request!.payload = payloadJSON.data(using: .utf8)
        
        var printedOutput: String?
        let semaphore = DispatchSemaphore(value: 0)
        
        lambda.invoke(request!) { (response, error) in
            defer { semaphore.signal() }

            if let error = error {
                print("Error invoking Lambda function: \(error)")
            } else if let payload = response?.payload {
                // Handle the response payload here
                //print("Lambda function response: \(payload)")
                //print("Help")
                var outputStream = RedirectedOutputStream(target: self)
                print("\(payload)", to: &outputStream)
                printedOutput = "\(payload)"
                //print("Captured output: \(printedOutput)")
            }
                //s3ObjectContent = printedOutput
                /*
                let urlString = extractURL(from: printedOutput)
                print("Extracted URL: \(urlString)")
                s3ObjectContent = urlString
                print("waht the heck")
                print("Type of s3ObjectContent: \(type(of: s3ObjectContent))")
                */
            semaphore.wait()
            return printedOutput

                
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
    LambdaHelper()
}
*/
