//
//  ContentView.swift
//  PhotoFInish
//
//  Created by Yuchen Zhu on 2/1/24.
//

import SwiftUI
import SwiftData
import UIKit

struct LoginPage2: View {
    @State private var selectedTab = 0
    
    
    var body: some View {
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
    }
}

struct YourFirstScreenView: View {
    var body: some View {
        Text("Your Pictures")
    }
}

struct YourSecondScreenView: View {
    var body: some View {
        // Your desired interface code for the second screen goes here
        VStack{
            ZStack{
                Color.black // Set the background color to black
                .edgesIgnoringSafeArea(.all)
                RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.gray)
                .frame(height: 700)
                .padding(30)
                RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.gray)
                .frame(width: 100, height: 150)
                .offset(x:-150, y:-230)
                RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.white)
                .frame(width: 70, height: 130)
                .offset(x:-110, y:260)
                                    /*
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(.red)
                                        .frame(width: 150, height: 700)
                                        .offset(x:90)
                                     */
                Circle()
                .foregroundColor(.white)
                .frame(width: 300)
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.white)
                    .frame(width:270,height:70)
                    VStack{
                        Text("PHOTO FINISH")
                        .font(.largeTitle)
                        .bold()
                        Text("Take a photo of you finishing😩💦")
                        .font(.caption)
                        .bold()
                                            
                    }
                }.offset(y:-230)
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.black)
                            .frame(width: 200, height: 30)
                            Text("Username")
                            .colorInvert()
                                        }
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 30)
                                                .foregroundColor(.black)
                                                .frame(width: 200, height: 30)
                                            Text("Passsword")
                                                .colorInvert()
                                        }
                                    }
                                    
                                }
                            }
                        }
            // Add your interface components here
        }
    


struct YourThirdScreenView: View {
    var body: some View {
        // Your desired interface code for the third screen goes here
        VStack {
            CameraViewController()

            // Add your interface components here
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage2()
    }
}



struct CameraViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraView {
        return CameraView()
    }
    
    func updateUIViewController(_ uiViewController: CameraView, context: Context) {
        // Update the view controller if needed
    }
}
