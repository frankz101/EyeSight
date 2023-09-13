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

enum ActiveSheet {
    case postMap, friendDetail
}


struct MapWithCameraButtonView: View {
    @State private var activeSheet: ActiveSheet? = nil

    @State private var selectedPostId: IdentifiablePostId? = nil
    @State private var isShowingFirstSheet = false
    @State private var isShowingDetailSheet = false
    @ObservedObject var sharedMapViewModel: SharedMapViewModel = SharedMapService.shared.sharedMapViewModel
    @ObservedObject var userLocationViewModel: UserLocationViewModel
    @ObservedObject var friendsViewModel: FriendsViewModel
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        ZStack {
            MapSubView(userLocationViewModel: userLocationViewModel, selectedPostId: $selectedPostId, isShowingFirstSheet: $isShowingFirstSheet, sharedMapViewModel: sharedMapViewModel)
            VStack {
                HStack {
                    if isShowingDetailSheet {
                        Button(action: {
                            isShowingDetailSheet = false
                        }) {
//                            Image(systemName: "xmark.circle")
//                                .padding()
//                                .font(.system(size:36))
//                                .background(Color.white.frame(width:40,height:40))
//                                .cornerRadius(8)
//                                .shadow(radius: 4)
                        }
                        Spacer()
                    }

                    if !isShowingDetailSheet {
                        Spacer()
                        Button(action: {
                            isShowingDetailSheet = true
                        }) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size:24))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(24)
                                .shadow(radius: 4)
                        }
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $isShowingDetailSheet, onDismiss: {
            }) {
                FriendDetailSheetView(friendsViewModel: friendsViewModel, viewModel: viewModel, sharedMapViewModel: sharedMapViewModel)
                    .presentationDetents([.medium,.large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
            .padding()










            //                                    MapViewRepresentable(userLocationViewModel: userLocationViewModel, onAnnotationTapped: { postId in
            //                                                            print("Annotation tapped: \(postId)")  // Debug print
            //                                        selectedPostId = IdentifiablePostId(id: postId, postId: postId)
            //                                        isShowingDetailSheet = true
            //                                    })
            //                                    .ignoresSafeArea()
            //                                    .padding(.bottom, 0.2)
            //                        //            .edgesIgnoringSafeArea(.top)
            //
            //                                    VStack {
            //                                        HStack {
            //                                            if isShowingDetailSheet {
            //                                                Button(action: {
            //                                                    isShowingDetailSheet = false
            //                                                }) {
            //                                                    Text("Close Details")
            //                                                        .padding()
            //                                                        .background(Color.white)
            //                                                        .cornerRadius(8)
            //                                                        .shadow(radius: 4)
            //                                                }
            //                                                Spacer() // Pushes the next button to the right when "Close Details" is shown
            //                                            }
            //
            //                                            if !isShowingDetailSheet {
            //                                                Spacer() // Pushes the "Show Details" button to the right
            //                                                Button(action: {
            //                                                    isShowingDetailSheet = true
            //                                                }) {
            //                                                    Text("Show Details")
            //                                                        .padding()
            //                                                        .background(Color.white)
            //                                                        .cornerRadius(8)
            //                                                        .shadow(radius: 4)
            //                                                }
            //                                            }
            //                                        }
            //                                        Spacer() // Pushes the HStack to the top
            //                                    }
            //                                    .padding()
            //                                }
            //                                .sheet(isPresented: $isShowingDetailSheet) {
            //                                    FriendDetailSheetView(friendsViewModel: friendsViewModel, viewModel: viewModel)
            //                                        .presentationDetents([.medium,.large])
            //                                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            //                                }





            //struct MapWithCameraButtonView: View {
            //    @State private var selectedPostId: IdentifiablePostId? = nil
            //    @State private var isShowingFirstSheet = true
            //    @ObservedObject var userLocationViewModel: UserLocationViewModel
            //    @ObservedObject var friendsViewModel: FriendsViewModel
            //    @ObservedObject var viewModel: ProfileViewModel
            //
            //    var body: some View {
            //        ZStack {
            //            MapViewRepresentable(userLocationViewModel: userLocationViewModel, onAnnotationTapped: { postId in
            //                selectedPostId = IdentifiablePostId(id: postId, postId: postId)
            //                isShowingFirstSheet = false
            //            })
            //            .edgesIgnoringSafeArea(.top)
            //            .sheet(isPresented: $isShowingFirstSheet, onDismiss: {
            //                if selectedPostId == nil {
            //                    isShowingFirstSheet = true
            //                }
            //            }) {
            //                FriendDetailSheetView(friendsViewModel: friendsViewModel, viewModel: viewModel)
            //                    .presentationDetents([.fraction(0.1),.medium,.large])
            //                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            //            }
            //            .sheet(item: $selectedPostId, onDismiss: {
            //                isShowingFirstSheet = true
            //                selectedPostId = nil
            //            }) { identifiablePostId in
            //                PostMapView(postId: identifiablePostId.postId)
            //                    .presentationDetents([.medium, .large])
            //                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            //            }

        }
    }

    struct MapSubView: View {
        @ObservedObject var userLocationViewModel: UserLocationViewModel
        @Binding var selectedPostId: IdentifiablePostId?
        @Binding var isShowingFirstSheet: Bool
        @ObservedObject var sharedMapViewModel: SharedMapViewModel

        var body: some View {
            MapViewRepresentable(onAnnotationTapped: { postId in
                selectedPostId = IdentifiablePostId(id: postId, postId: postId)
                isShowingFirstSheet = false
            })
//            MapViewRepresentable(userLocationViewModel: userLocationViewModel, sharedMapViewModel: sharedMapViewModel, onAnnotationTapped: { postId in
//                selectedPostId = IdentifiablePostId(id: postId, postId: postId)
//                isShowingFirstSheet = false
//            })
            .edgesIgnoringSafeArea(.top)
            .sheet(item: $selectedPostId, onDismiss: {
                isShowingFirstSheet = true
                selectedPostId = nil
            }) { identifiablePostId in
                PostMapView(postId: identifiablePostId.postId)
                    .presentationDetents([.medium, .large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
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


}
