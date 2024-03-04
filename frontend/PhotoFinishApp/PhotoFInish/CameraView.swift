//
//  CameraView.swift
//  PhotoFInish
//
//  Created by Samarth Srinivasa on 2/19/24.
//

import AVFoundation
import UIKit
import SwiftUI

class CameraView: UIViewController {
    
    var session: AVCaptureSession?
    
    let output = AVCapturePhotoOutput() //Photo Output
    
    let previewLayer = AVCaptureVideoPreviewLayer() //video preview!!
    
    private let shutter: UIButton = { //Size and color of Camera button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .black //making background black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutter)
        
        //connecting shutter button to actual function
        shutter.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
        checkCameraPermissions()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutter.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 100)
    }
    
    private func checkCameraPermissions() { //For checking just breaking if not authorized
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    //self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
        
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device) //seems redundant but apple likes it this way??
                if session.canAddInput(input) { //just to make sure this can run on the sim as well
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) { //just to make sure this can run on the sim as well
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning() //keeping the camera app running
                self.session = session
                
                
                
                
            }
            catch {
                print(error) //error check
                
            }
        }
    }
    
    @objc private func didTapTakePhoto() { //omg actually taking the photo
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

extension CameraView: AVCapturePhotoCaptureDelegate { //I had this ERROR FOR 2 HOURS BEFORE I REALIZED I SPELLED //EXTENTION WRONGG!!!!

    
    //giving photo back as a parameter
    
    func photoOutput(_ output:AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error:Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        
        
        
    }
        
}

