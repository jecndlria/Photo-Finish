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

var user = UsernameManager.shared.username


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
                
                SecondScreenView()
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("Camera")
                    }
                    .tag(1)
                ThirdScreenView()
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

    var body: some View {
        YourSecondScreenView()
    }
}

struct ThirdScreenView: View {
    var body: some View {
        YourThirdScreenView()
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
    
    var body: some View {
        // Your desired interface code for the second screen goes here
        VStack{
            FeedView()
            //Text("Saved Pictures")

        }
    }
            // Add your interface components here
}
    


struct YourSecondScreenView: View {
   // Add binding for captured image

    var body: some View {
        VStack {
            CameraViewController()
        }

    }
}

struct ContentView_Previews: PreviewProvider { //content contained
    static var previews: some View {
        LoginPage2()
    }
}

struct CameraViewController: UIViewControllerRepresentable { //contained
    func makeUIViewController(context: Context) -> CameraView {
        //return CameraView()
        //let cameraView = CameraView()
        //capturedImage2 = capturedImage // Pass capturedImage to CameraView
        
        return CameraView()
    }
    
    func updateUIViewController(_ uiViewController: CameraView, context: Context) {
        // Update the view controller if needed
    }
}
