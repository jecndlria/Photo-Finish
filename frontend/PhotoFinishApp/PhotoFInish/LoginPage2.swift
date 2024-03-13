//
//  ContentView.swift
//  PhotoFInish
//
//  Created by Yuchen Zhu on 2/1/24.
//

import SwiftUI
import SwiftData
import UIKit
import AVFoundation

@MainActor
struct LoginPage2: View {
    @State var selectedTab = 0
    @State var capturedImage: UIImage?
    //@IBOutlet weak var imageView: UIImageView!
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                FirstScreenView()
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("Pictures")
                    }
                    .tag(0)
                
                SecondScreenView(capturedImage: $capturedImage)
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("Camera")
                    }
                    .tag(1)
                ThirdScreenView(capturedImage: $capturedImage)
                    .tabItem {
                        Image(systemName: "3.square.fill")
                        Text("Friends")
                        
                    }
                    .tag(2)
            }
        }
        //.ignoresSafeArea()
    }
}

struct FirstScreenView: View {
    var body: some View {
        YourFirstScreenView()
    }
}

struct SecondScreenView: View {
    @Binding var capturedImage: UIImage?

    var body: some View {
        YourSecondScreenView(capturedImage: $capturedImage) 
    }
}

struct ThirdScreenView: View {
    @Binding var capturedImage: UIImage?
    var body: some View {
        YourThirdScreenView(capturedImage: $capturedImage)
        //FeedView()
    }
}

struct YourFirstScreenView: View {
    //@Binding var capturedImages: [UIImage]
    var body: some View {
          //Text("hello")
        ProfileLeaderboard()
    }
}
 
    


struct YourThirdScreenView: View {
    @Binding var capturedImage: UIImage?
    var body: some View {
        // Your desired interface code for the second screen goes here
        VStack{
            FeedView(capturedImage: $capturedImage)
            //Text("Saved Pictures")

        }
    }
            // Add your interface components here
}
    


struct YourSecondScreenView: View {
    @Binding var capturedImage: UIImage? // Add binding for captured image
    var body: some View {
        VStack {
            CameraViewController(capturedImage: $capturedImage)
        }

    }
}

struct ContentView_Previews: PreviewProvider { //content contained
    static var previews: some View {
        LoginPage2()
    }
}

struct CameraViewController: UIViewControllerRepresentable { //contained
    @Binding var capturedImage: UIImage?
    func makeUIViewController(context: Context) -> CameraView {
        //return CameraView()
        let cameraView = CameraView()
        cameraView.capturedImage = capturedImage // Pass capturedImage to CameraView
        return cameraView
    }
    
    func updateUIViewController(_ uiViewController: CameraView, context: Context) {
        // Update the view controller if needed
    }
}
