//
//  FeedView.swift
//  PhotoFInish
//
//  Created by Samarth Srinivasa on 3/11/24.
//

import Foundation
import SwiftUI
import AWSLambda
import AWSCore



extension String {
    func toImage() -> UIImage! {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    
}

struct FeedView: View {
    
    @State var currentIndex = 0 // Start with the first image visible
    @State var swipeOffset: CGFloat = 0 // Track swipe offset for smooth animation
    @State var places: [Place] = []
    @State var showPersonalView = false
    
    @State var printedOutput = ""
    struct RedirectedOutputStream: TextOutputStream {
                var target: FeedView

                mutating func write(_ string: String) {
                    target.printedOutput.append(string)
        }
    }
    func lambdacalling() {
        
        let lambda = AWSLambda.default()
        let request = AWSLambdaInvocationRequest()
        request!.functionName = "get_feed"
        request!.invocationType = .requestResponse
        request!.payload = """
    {
        \"username\": "\(user)",
        \"object_key\": "AHAHHAHAH"
    }
    """
        lambda.invoke(request!) { (response, error) in
            if let error = error {
                print("Error invoking Lambda function: \(error)")
            } else if let payload = response?.payload {
                //as? Data, let payloadString = String(data: payload, encoding: .utf8)
                // Handle the response payload here
                print("Lambda function response: \(payload)")
                var outputStream = RedirectedOutputStream(target: self)
                print("\(payload)", to: &outputStream)
                //print("Captured output: \(self.printedOutput)")
                if printedOutput.contains("200") {
                    places.removeAll()
                    let components = printedOutput.split { $0 == "," || $0 == "\n" }
                    for component in components {
                        let keyValue = component.split(separator: "=")
                        print(keyValue)
                        guard keyValue.count == 2 else {
                            continue
                        }
                        let key = keyValue[0].trimmingCharacters(in: .whitespaces)
                        let value = keyValue[1].trimmingCharacters(in: .whitespaces)
                        
                        let cleanedKey = key.replacingOccurrences(of: "\"", with: "")
                        let cleanedValue = value.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ";", with: "")
                        
                        print(cleanedKey)
                        print(cleanedValue)
                        
                        
                        
                        if cleanedKey != "statusCode" && cleanedKey != "body" && cleanedKey != "payload" {
                            let newEntry = Place(name: cleanedKey, image: cleanedValue.toImage() ,description: cleanedValue)
                            places.append(newEntry)
                        }
                    }
                }
            }
        }
    }
    
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 1) {
                    Button("Go to Personal View") {
                                                showPersonalView = true
                                            }
                                            .sheet(isPresented: $showPersonalView) {
                                                PersonalView()
                                            }
                    Text("Pictures from the daily feed")
                                        .font(.title)
                                        .foregroundColor(.white) // Set text color to white
            
                                        .background(Color.black)
                                        .onAppear{
                                            places.removeAll()
                                            lambdacalling()
                                        }
                    ForEach(places.indices, id: \.self) { index in
                        
                        VStack {
                            AsyncImage(url: URL(string: places[index].description)){ image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }

                            
                            //Image(uiImage: places[index].image ?? UIImage())
                            //Image(places[index].image)//places[index].image)
                                //.resizable()
                                //.aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.90, height: geometry.size.height * 0.80)
                                .cornerRadius(50)
                                .shadow(radius: 5)
                                .offset(x: swipeOffset)
                                //.edgesIgnoringSafeArea(.all)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            swipeOffset = value.translation.width - geometry.size.width * CGFloat(currentIndex)
                                        }
                                        .onEnded { value in
                                            let threshold = geometry.size.width * 0.8 // Threshold for swipe
                                            if abs(value.translation.width) > threshold {
                                                /*
                                                // Swipe to the next or previous image
                                                withAnimation {
                                                    currentIndex += Int(-value.translation.width / value.translation.width)
                                                    swipeOffset = -geometry.size.width * CGFloat(currentIndex)
                                                }
                                            } else {*/
                                                // Snap back to the current image
                                                withAnimation {
                                                    swipeOffset = -geometry.size.width * CGFloat(currentIndex)
                                                }
                                            }
                                        }
                                )
                                //.padding(.top, 50) // Center the image vertically
                            Text(places[index].name)
                                .font(.body)
                            //Text()
                             //   .font(.body)
                           
                        }
                    }
                }
                .padding(.horizontal)
                .foregroundColor(.white)
                .bold()
            }
        }
        //.padding()
        //.edgesIgnoringSafeArea(.all)
        .background(.black)
        .onAppear {
            // Start a timer to update the places array periodically
            /*
            if takenPic != nil {
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                    // Here, you can fetch new images or data and append them to the places array
                    places.append(Place(name: user, image: takenPic, description: urlpass))
                    timer.invalidate()
                }
            }
             */
        places.append(Place(name: user, image: takenPic ?? UIImage(), description: urlpass))

        }
    }
    
}

#Preview {
    FeedView()
}
struct Place: Hashable {
    let name: String
    let image: UIImage?
    let description: String
    
    init(name: String, image: UIImage?, description: String) {
            self.name = name
            self.image = image
            self.description = description
        }

        init(name: String, imageString: String, description: String) {
            self.name = name
            self.image = UIImage(named: "Rome")!
            self.description = description
        }
}


