//
//  ViewController.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import CoreLocation

class ViewController: UIViewController {
    let locationManager = LocationManager()
    //MARK:- Vars
    var captureSession : AVCaptureSession!
    var onImageCaptured: ((UIImage) -> Void)?
    
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var backInput : AVCaptureInput!
    var frontInput : AVCaptureInput!
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var videoOutput : AVCaptureVideoDataOutput!
    
    var takePicture = false
    var backCameraOn = true
    
    

    
    //MARK:- View Components
    let switchCameraButton : UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "arrow.triangle.2.circlepath.camera") {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    let captureImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear  // Transparent background
        button.layer.borderWidth = 8     // Width of the border
        button.layer.borderColor = UIColor.white.cgColor // Color of the border
        button.layer.cornerRadius = 40   // Corner radius should be half of the width and height
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let retakeButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "camera.on.rectangle") {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .white
        button.isHidden = true // Initially hide the retake button
        button.addTarget(self, action: #selector(retakeImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    
    let capturedImageView = CapturedImageView()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        capturedImageView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
        setupAndStartCaptureSession()
    }
    
    
    //MARK:- Camera Setup
    func setupAndStartCaptureSession(){
        DispatchQueue.global(qos: .userInitiated).async{
            //init session
            self.captureSession = AVCaptureSession()
            //start configuration
            self.captureSession.beginConfiguration()
            
            //session specific configuration
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            //setup inputs
            self.setupInputs()
            
            DispatchQueue.main.async {
                //setup preview layer
                self.setupPreviewLayer()
            }
            
            //setup output
            self.setupOutput()
            
            //commit configuration
            self.captureSession.commitConfiguration()
            //start running it
            self.captureSession.startRunning()
        }
    }
    
    func setupInputs(){
        //get back camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
        } else {
            //handle this appropriately for production purposes
            fatalError("no back camera")
        }
        
        //get front camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = device
        } else {
            fatalError("no front camera")
        }
        
        //now we need to create an input objects from our devices
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("could not create input device from back camera")
        }
        backInput = bInput
        if !captureSession.canAddInput(backInput) {
            fatalError("could not add back camera input to capture session")
        }
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("could not create input device from front camera")
        }
        frontInput = fInput
        if !captureSession.canAddInput(frontInput) {
            fatalError("could not add front camera input to capture session")
        }
        
        //connect back camera input to session
        captureSession.addInput(backInput)
    }
    
    func setupOutput(){
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, below: switchCameraButton.layer)
        previewLayer.frame = self.view.layer.frame
    }
    
    func switchCameraInput(){
        //don't let user spam the button, fun for the user, not fun for performance
        switchCameraButton.isUserInteractionEnabled = false
        
        //reconfigure the input
        captureSession.beginConfiguration()
        if backCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            backCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            backCameraOn = true
        }
        
        //deal with the connection again for portrait mode
        videoOutput.connections.first?.videoOrientation = .portrait
        
        //mirror the video stream for front camera
        videoOutput.connections.first?.isVideoMirrored = !backCameraOn
        
        //commit config
        captureSession.commitConfiguration()
        
        //acitvate the camera button again
        switchCameraButton.isUserInteractionEnabled = true
    }
    
    
    //firebase stuff
    func uploadImageToFirebase(uiImage: UIImage) {
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated")
            return
        }
        
        let uid = user.uid
        let db = Firestore.firestore()

        // Fetch the user's full name from Firestore
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let fullName = data?["fullName"] as? String ?? "Unknown User"

                // Fetch the user's location
                guard let currentLocation = self.locationManager.currentLocation else {
                    print("Could not fetch user's current location")
                    return
                }

                // Convert coordinates to place names
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                    if let error = error {
                        print("Geocoding error: \(error)")
                        return
                    }
                    guard let placemark = placemarks?.first else {
                        print("No placemarks available")
                        return
                    }

                    // Get the state and town
                    let state = placemark.administrativeArea ?? ""
                    let town = placemark.locality ?? ""

                    // Convert the UIImage to Data
                    guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else { return }

                    // Create a storage reference
                    let storage = Storage.storage()
                    let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")

                    // Upload the data
                    let uploadMetadata = StorageMetadata()
                    uploadMetadata.contentType = "image/jpeg"

                    storageRef.putData(imageData, metadata: uploadMetadata) { metadata, error in
                        guard error == nil else {
                            // handle error
                            return
                        }
                        storageRef.downloadURL { url, error in
                            guard let downloadURL = url else {
                                // handle error
                                return
                            }

                            // Now, create a comment section in Firestore
                            let commentSectionID = UUID().uuidString
                            let newCommentSection = CommentSection(id: commentSectionID, participants: [])
                            do {
                                try db.collection("commentSections").document(commentSectionID).setData(from: newCommentSection)
                            } catch let error {
                                print("Error writing comment section to Firestore: \(error)")
                            }

                            // Create a post in Firestore
                            let post = Post(id: UUID().uuidString, userID: uid, username: fullName, imageURL: downloadURL.absoluteString, timestamp: Timestamp(date: Date()), location: GeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), state: state, town: town, commentSectionID: commentSectionID)

                            do {
                                try db.collection("posts").document(post.id).setData(from: post)
                                
                                // Update hasPostedToday to true
                                db.collection("users").document(uid).updateData([
                                    "hasPostedToday": true
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                                
                            } catch let error {
                                print("Error writing post to Firestore: \(error)")
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }






    
    //MARK:- Actions
    @objc func captureImage(_ sender: UIButton?){
        takePicture = true
        previewLayer.isHidden = true
        capturedImageView.isHidden = false
        captureImageButton.isHidden = true
        switchCameraButton.isHidden = true;
        retakeButton.isHidden = false;
        
        

        
        
        let submitButton = UIButton(type: .system) // Use .system type to respect the system's default button appearance

        // Set button properties
        submitButton.setTitle("Post", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28) // Adjust font size and style as needed
        submitButton.setTitleColor(.white, for: .normal)

        // Calculate the x coordinate to horizontally center the button relative to captureImageButton
        let xCoordinate = captureImageButton.frame.origin.x + (captureImageButton.frame.width - 200) / 2

        // Set the button's frame with the calculated x coordinate
        submitButton.frame = CGRect(x: xCoordinate,
                                    y: captureImageButton.frame.origin.y,
                                    width: 200,
                                    height: 50)

        // Set a tag to identify the button later if needed (as you did before)
        submitButton.tag = 999

        // Add a target for the button's action
        submitButton.addTarget(self, action: #selector(submitImage), for: .touchUpInside)

        // Add the button to the view
        self.view.addSubview(submitButton)

    }
    
    @objc func submitImage() {
            guard let image = self.capturedImageView.image else { return }
            self.uploadImageToFirebase(uiImage: image)
            onImageCaptured?(image)
        }
    
    @objc func switchCamera(_ sender: UIButton?){
        switchCameraInput()
    }
    
    @objc func retakeImage() {
        previewLayer.isHidden = false // Show the video preview
        capturedImageView.isHidden = true // Hide the captured image view
        captureImageButton.isHidden = false // Show the "Capture Image" button
        switchCameraButton.isHidden = false;
        retakeButton.isHidden = true // Hide the "Retake" button
        
        // Remove the submitButton from its superview
        if let submitButton = self.view.subviews.first(where: { $0 is UIButton && $0.tag == 999 }) {
            submitButton.removeFromSuperview()
        }
    }


}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !takePicture {
            return //we have nothing to do with the image buffer
        }
        
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        //get UIImage out of CIImage
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async {
            self.capturedImageView.image = uiImage
            self.takePicture = false
        }
    }
}

