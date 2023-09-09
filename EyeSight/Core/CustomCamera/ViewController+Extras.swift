//
//  ViewController+Extras.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import Foundation
import UIKit
import AVFoundation

extension ViewController {
    //MARK:- View Setup
    func setupView(){
       view.backgroundColor = .black
       view.addSubview(switchCameraButton)
       view.addSubview(captureImageButton)
       view.addSubview(capturedImageView)
        view.addSubview(retakeButton)
       
       NSLayoutConstraint.activate([
           switchCameraButton.widthAnchor.constraint(equalToConstant: 60),
           switchCameraButton.heightAnchor.constraint(equalToConstant: 60),
           switchCameraButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
           switchCameraButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
           
           captureImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
           captureImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
           captureImageButton.widthAnchor.constraint(equalToConstant: 80),
           captureImageButton.heightAnchor.constraint(equalToConstant: 80),
           
           capturedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           capturedImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           capturedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1), // Adjust the multiplier for the desired width
           capturedImageView.heightAnchor.constraint(equalTo: capturedImageView.widthAnchor, multiplier: 4.0 / 3.0), // Maintain a 4:5 aspect ratio


           
           retakeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10), // Adjust the top constraint as needed
           retakeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10), // Adjust the left constraint as needed
           retakeButton.widthAnchor.constraint(equalToConstant: 80),
           retakeButton.heightAnchor.constraint(equalToConstant: 40),
       ])
       
       switchCameraButton.addTarget(self, action: #selector(switchCamera(_:)), for: .touchUpInside)
       captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
    }
    
    //MARK:- Permissions
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
          case .authorized:
            return
          case .denied:
            abort()
          case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
            { (authorized) in
              if(!authorized){
                abort()
              }
            })
          case .restricted:
            abort()
          @unknown default:
            fatalError()
        }
    }
}
