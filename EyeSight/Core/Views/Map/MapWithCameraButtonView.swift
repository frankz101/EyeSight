//
//  MapWithCameraButtonView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/18/23.
//

import SwiftUI

struct IdentifiablePostId: Identifiable {
    let id: String
    let postId: String
}

struct MapWithCameraButtonView: View {
    @State private var selectedPostId: IdentifiablePostId? = nil
    @ObservedObject var userLocationViewModel: UserLocationViewModel

    var body: some View {
        ZStack {
            MapViewRepresentable(userLocationViewModel: userLocationViewModel, onAnnotationTapped: { postId in
                selectedPostId = IdentifiablePostId(id: postId, postId: postId)
            })
            .sheet(item: $selectedPostId, onDismiss: {
                print("Sheet dismissed")
            }) { identifiablePostId in
                PostMapView(postId: identifiablePostId.postId)
                    .presentationDetents([.medium, .large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
        }
    }
}


//struct MapWithCameraButtonView: View {
//    @State private var showModal = false
//    @State var isSheetPresented = false
//    @State var selectedPostId: String? = nil   // Add this line
//    @ObservedObject var userLocationViewModel: UserLocationViewModel
//
//    var body: some View {
//        ZStack {
//            MapViewRepresentable(userLocationViewModel: userLocationViewModel, onAnnotationTapped: { postId in
//                selectedPostId = postId
//                isSheetPresented = true
//            })
//                .sheet(isPresented: $isSheetPresented) {
//                    if let postId = selectedPostId {
//                        PostMapView(postId: postId)
//                            .presentationDetents([.medium, .large])
//                            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
//                    } else {
//                        Text("No post selected")
//                    }
//                }
//
//            // Uncomment and adjust the below code as per your needs
//            /*
//            Button(action: {
//                showModal.toggle()
//            }) {
//                Text("Open Camera")
//                    .font(.title)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .offset(y: -50)  // Adjust this value as needed
//            .sheet(isPresented: $showModal) {
//                CameraViewControllerRepresentable { image in
//                    print(image)
//                    // Set showModal to false to close the modal
//                    self.showModal = false
//                }
//            }
//            */
//        }
//    }
//}



//struct MapWithCameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userLocationViewModel = UserLocationViewModel()
//        let locationManager = LocationManager() // Create a new instance of LocationManager
//        return MapWithCameraButtonView(userLocationViewModel: userLocationViewModel, isActiveTab: .constant(true))
//            .environmentObject(UserPhotoViewModel())
//            .environment(\.locationManager, locationManager) // Pass the locationManager as an environment value
//    }
//}

