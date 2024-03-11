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
    @State private var selectedTab = 0
    //@State private var capturedImages: [UIImage] = []

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
    //@Binding var capturedImages: [UIImage]
    var body: some View {
          Text("hello")
    }
}
 
    


struct YourThirdScreenView: View {
    var body: some View {
        // Your desired interface code for the second screen goes here
        VStack{
            Text("Saved Pictures")
        }
    }
            // Add your interface components here
}
    


struct YourSecondScreenView: View {
    //@StateObject var camera = CameraModel()
    var body: some View {
        VStack {
            CameraViewController()
        }
        // Your desired interface code for the third screen goes here
       /*
        ZStack {
            
            //Camera Preivew
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            VStack {
                
                if camera.isTaken {
                    HStack {
                        Spacer()
                        Button(action: camera.reTake, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 10)
                        
                    }
                }
                
                Spacer()
                
                HStack {
                    if camera.isTaken {
                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        Spacer()
                        
                        
                    } else {
                        Button(action: camera.takePic, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                                
                            }
                            
                        })
                    }
                }
                .frame(height: 75)
                
            }
            .onAppear(perform: {
                camera.Check()
            })
            
            //CameraViewController()

            // Add your interface components here
        }
        */
    }
}

struct ContentView_Previews: PreviewProvider { //content contained
    static var previews: some View {
        LoginPage2()
    }
}

struct CameraViewController: UIViewControllerRepresentable { //contained
    func makeUIViewController(context: Context) -> CameraView {
        return CameraView()
    }
    
    func updateUIViewController(_ uiViewController: CameraView, context: Context) {
        // Update the view controller if needed
    }
}

/*

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    //for reading the picture output data
    @Published var output = AVCapturePhotoOutput()
    
    //preview functionality
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    //pic Data...
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    
    func Check() { //check Contained
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
        
    }
    private func setUp() { //setup contained
        
        //camera setup
        
        let session = AVCaptureSession()
        
        do {
            
            self.session.beginConfiguration()
            
            //change configurations to your own
            //let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            let device = AVCaptureDevice.default(for: .video)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            //input - checking and adding to the session
            if self.session.canAddInput(input) {
                self.session.addInput(input)

            }
            //output
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()

        }
        catch{
            print(error)
        }
    }
    
    // take and retake functionality
    
    func takePic() { //takePic contained
        DispatchQueue.global(qos: .background).async    {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            //self.session.stopRunning()
            
            DispatchQueue.main.async {
                //withAnimation {self.isTaken.toggle()}
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {(timer) in self.session.stopRunning()}
            }
            self.session.stopRunning()
        }
    }
    
                            func reTake() { //retake contained
                                DispatchQueue.global(qos: .background).async {
                                    self.session.startRunning()
                                    
                                    DispatchQueue.main.async {
                                        withAnimation {self.isTaken.toggle()}
                                        //clearing picture data to retake
                                        self.isSaved = false
                                        
                                    }
                                }
                            }
                                
                                func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) { //output contained
                                    if error != nil {
                                        return
                                    }
                                    print("Pic taken")
                                    
                                    guard let imageData = photo.fileDataRepresentation() else{return}
                                    
                                    self.picData = imageData
                                }
                                
                                func savePic() { //savePic contained
                                    
                                    let image = UIImage(data: self.picData)!
                                    
                                    //finally saves the image
                                    
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                    
                                    self.isSaved = true
                                    
                                    print("Saved to phone successfully")
                                }
                                
}

//view for the preview

struct CameraPreview: UIViewRepresentable { //UIview contained
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        //your own properties?
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        //starting session
        
        camera.session.startRunning()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
*/
