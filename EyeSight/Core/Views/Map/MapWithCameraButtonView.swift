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
                            // Your existing button
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

                Spacer() // Pushes buttons to the bottom

                HStack {
                    Button(action: {
                        sharedMapViewModel.toggleUserCustomAnnotations()
                    }) {
                        Text("Toggle User Annotations")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Spacer() // Separates the buttons

                    Button(action: {
                        sharedMapViewModel.toggleCustomAnnotations()
                    }) {
                        Text("Toggle Custom Annotations")
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)  // Add some horizontal padding
            }
            .padding(.bottom) // Add some bottom padding
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



