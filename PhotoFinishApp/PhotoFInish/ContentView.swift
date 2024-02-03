//
//  ContentView.swift
//  PhotoFInish
//
//  Created by Yuchen Zhu on 2/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View{
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
        
}

struct ContentView_Previews:
    PreviewProvider{
    static var previews: some
        View{
            ContentView()
        }
}
