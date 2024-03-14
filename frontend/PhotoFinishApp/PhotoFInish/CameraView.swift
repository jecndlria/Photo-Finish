//
//  CameraView.swift
//  PhotoFInish
//
//  Created by Samarth Srinivasa on 2/19/24.
//

import AVFoundation
import UIKit
import SwiftUI
import AWSS3
import AWSLambda
import AWSCore


var takenPic: UIImage!
var timeOfButtonClick: Date?
var dateString: String!
var urlpass: String!


protocol CameraViewDelegate: AnyObject {
    func didFinishCapturingImage(_ image: UIImage)
}


class CameraView: UIViewController {
    @State private var printedOutput = ""
    struct RedirectedOutputStream: TextOutputStream {
                var target: CameraView

                mutating func write(_ string: String) {
                    target.printedOutput.append(string)
                }
            }
    
    var timeOfButtonClick: Date?

    //var delegate: CameraViewDelegate?
    
    var capturedImage: UIImage?
    
    var session: AVCaptureSession?
    
    let output = AVCapturePhotoOutput() //Photo Output
    
    let previewLayer = AVCaptureVideoPreviewLayer() //video preview!!
    
    private var currentCameraPosition: AVCaptureDevice.Position = .back
        
    private let shutter: UIButton = { //Size and color of Camera button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(shutterButtonPressed), for: .touchUpInside) // Add target for button press

        return button
    } ()
    
    //added button for saving pictures
    private let saveButton: UIButton = {
            let button = UIButton()
            button.setTitle("Save", for: .normal)
            button.backgroundColor = .blue
            button.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
            return button
        }()
    
    //added button for restarting video session
    private let restartButton: UIButton = {
            let button = UIButton()
            button.setTitle("Restart", for: .normal)
            button.backgroundColor = .red
            button.addTarget(self, action: #selector(restartCameraSession), for: .touchUpInside)
        
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black //making background black
        view.layer.addSublayer(previewLayer)

        view.addSubview(saveButton)
        view.addSubview(restartButton)
        view.addSubview(shutter)

        //previewLayer.addSublayer(saveButton.layer)
        //previewLayer.addSublayer(restartButton.layer)
        
        //connecting shutter button to actual function
        shutter.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
        checkCameraPermissions()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
                tapGesture.numberOfTapsRequired = 2
                view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutter.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 100)
        //let buttonSize = CGSize(width: 100, height: 50)
        //saveButton.frame = CGRect(x: (view.frame.size.width - buttonSize.width) / 2, y: view.frame.size.height - 100, width: buttonSize.width, height: buttonSize.height)
        //restartButton.frame = CGRect(x: view.frame.size.width - buttonSize.width - 20, y: view.frame.size.height - 100, width: buttonSize.width, height:buttonSize.height)
        saveButton.frame = CGRect(x: 20, y: view.frame.size.height - 120, width: 100, height: 50)
        restartButton.frame = CGRect(x: view.frame.size.width - 120, y: view.frame.size.height - 120, width: 100, height: 50)
            
    }
    
    @objc func shutterButtonPressed() {
        // Save the current date and time when the button is pressed
        timeOfButtonClick = Date()
        if let time = timeOfButtonClick {
                dateString = dateFormatter.string(from: time)
                urlpass = dateFormatter.string(from: time)
                print("Button clicked at: \(dateString ?? "Date not available")")
            }
        // You can access timeOfButtonClick later to get the exact time
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Specify your desired date format
        
        return formatter
    }()
    
    let dateFormatter1: DateFormatter = {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = urlpass // Specify your desired date format
        
        return formatter1
    }()
    
    @objc private func didDoubleTap() {
            // Toggle between front and back camera positions
            currentCameraPosition = currentCameraPosition == .back ? .front : .back
            
            // Remove existing inputs and add new input for the toggled camera
            if let session = session {
                session.beginConfiguration()
                for input in session.inputs {
                    session.removeInput(input)
                }
                addCameraInput(position: currentCameraPosition)
                session.commitConfiguration()
            }
        }
    
    
    
    @objc private func savePhoto() {
            guard let image = capturedImage else {
                return
            }
        let sanitizedUrlPass = urlpass.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        // Upload the image to S3
        let transferUtility = AWSS3TransferUtility.default()
        let objectKey = "\(user)\(sanitizedUrlPass).png" 
        let imageData = image.jpegData(compressionQuality: 0.8)!

        transferUtility.uploadData(
            imageData,
            bucket: "photo-finish-bucket",
            key: objectKey,
            contentType: "image/jpeg",
            expression: nil
        ) { (task, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully = \(objectKey)")
                let lambda = AWSLambda.default()
                let request = AWSLambdaInvocationRequest()
                request!.functionName = "uploadS3Object"
                request!.invocationType = .requestResponse
                request!.payload = """
                {
                    \"username\": "\(user)",
                    \"object_key\": "\(objectKey)"
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
                                        print("Lambda function response: \(payload)", to: &outputStream)
                                        //print("Captured output: \(self.printedOutput)")
                                        
                                        //self.restartCameraSession()
                        
                                    }
                                }
                            
                 
            }
        }
        
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("Saved to phone successfully")
            takenPic = image
            UIImageWriteToSavedPhotosAlbum(takenPic, nil, nil, nil)

    }
    
    
    
    @objc private func restartCameraSession() {
            session?.startRunning()
            // Remove the captured image view if it exists
            //isPhotoTaken = false
            //saveButton.isEnabled = true
            view.subviews.compactMap { $0 as? UIImageView }.forEach { $0.removeFromSuperview() }
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
        //isPhotoTaken = true
        //saveButton.isEnabled = false
        
    }
    private func addCameraInput(position: AVCaptureDevice.Position) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            print("Failed to get \(position) camera.")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session!.canAddInput(input) {
                session!.addInput(input)
            }
        } catch {
            print("Error setting device input: \(error)")
        }
    }
}

extension CameraView: AVCapturePhotoCaptureDelegate { //I had this ERROR FOR 2 HOURS BEFORE I REALIZED I SPELLED //EXTENTION WRONGG!!!!

    
    //giving photo back as a parameter
    
    func photoOutput(_ output:AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error:Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        //capturedImage = UIImage(data: data)
        
        //delegate?.didFinishCapturingImage(image!)
        capturedImage = image
        //delegate?.didFinishCapturingImage(image!)
        
        
        
        //session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        view.bringSubviewToFront(saveButton)
        view.bringSubviewToFront(restartButton)
        view.bringSubviewToFront(shutter)
        
        
        
        
    }
        
}