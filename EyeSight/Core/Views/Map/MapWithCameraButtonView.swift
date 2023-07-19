//
//  MapWithCameraButtonView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/18/23.
//

import SwiftUI

struct MapWithCameraButtonView: View {
    @State private var showModal = false
    @ObservedObject var userLocationViewModel: UserLocationViewModel

    var body: some View {
        ZStack {
            MapViewRepresentable(userLocationViewModel: userLocationViewModel)

            Button(action: {
                showModal.toggle()
            }) {
                Text("Open Camera")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .offset(y: -50)  // Adjust this value as needed
            .sheet(isPresented: $showModal) {
                CameraViewControllerRepresentable { image in
                    print(image)
                    // Set showModal to false to close the modal
                    self.showModal = false
                }
            }
        }
    }
}


//struct MapWithCameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userLocationViewModel = UserLocationViewModel()
//        let locationManager = LocationManager() // Create a new instance of LocationManager
//        return MapWithCameraButtonView(userLocationViewModel: userLocationViewModel, isActiveTab: .constant(true))
//            .environmentObject(UserPhotoViewModel())
//            .environment(\.locationManager, locationManager) // Pass the locationManager as an environment value
//    }
//}

