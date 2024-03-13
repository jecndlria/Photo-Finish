//
//  FeedView.swift
//  PhotoFInish
//
//  Created by Samarth Srinivasa on 3/11/24.
//

import Foundation
import SwiftUI

struct FeedView: View {
    @State var currentIndex = 0 // Start with the first image visible
    @State var swipeOffset: CGFloat = 0 // Track swipe offset for smooth animation
    @State var places: [Place] = []
    
    //let places: [Place] = [
     //  Place(name: "Yuzu", image: takenPic, description: "On da Table")
        
    //]
    
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 1) {
                    Text("Pictures from the daily feed")
                                        .font(.title)
                                        .foregroundColor(.white) // Set text color to white
            
                                        .background(Color.black)
                    ForEach(places.indices, id: \.self) { index in
                        
                        VStack {
                            Image(uiImage: places[index].image ?? UIImage())
                            //Image(places[index].image)//places[index].image)
                                .resizable()
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
                                .padding(.top, 50) // Center the image vertically
                            Text(places[index].name)
                                .font(.body)
                            Text(places[index].description)
                                .font(.body)
                           
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
            if takenPic != nil {
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                    // Here, you can fetch new images or data and append them to the places array
                    places.append(Place(name: "Yuzu", image: takenPic, description: "On da Table"))
                    timer.invalidate()
                }
            }
        }
    }
}
#Preview {
    FeedView()
}
struct Place: Hashable {
    let name: String
    let image: UIImage!
    let description: String
    
    init(name: String, image: UIImage, description: String) {
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
