//
//  ProfileView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/27/23.
//

import SwiftUI
import Kingfisher
import TOCropViewController

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var authViewModel: AuthService
    @State private var showCropView = false
    @State private var showImagePicker = false
    @State private var showImageCropper = false
    @StateObject var feedViewModel = FeedViewModel()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var currentActionSheet: ActionSheetType?
    
    enum ActionSheetType: String, Identifiable {
        case main, changeProfile

        var id: String {
            self.rawValue
        }
    }


    var body: some View {
        VStack {
            // Header
            HStack {
                Text("profile")
                    .font(.largeTitle).bold()
                Spacer()
                Button(action: {
                    currentActionSheet = .main
                }) {
                    if let urlString = viewModel.user?.profileImageURL, let url = URL(string: urlString) {
                        KFImage(url)
                            .resizable()
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                    }
                }
                .frame(width: 48, height: 48)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            
            if let post = viewModel.recentPostId {
                PostMapView(postId: post)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: .infinity, height: 600) // Adjust the dimensions as per your requirements
                    .overlay(
                        CameraTestView(returnToMapView: {print("image captured")})
                    )
                    .cornerRadius(10)
                    .padding(.bottom, 16)
            }
            
            Spacer()

            VStack {
            }
            .sheet(isPresented: $showImagePicker, onDismiss: {
                if selectedImage != nil {
                    showImageCropper = true
                }
            }) {
                ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
            }
            .fullScreenCover(isPresented: $showImageCropper, onDismiss: {
                if let image = selectedImage {
                    viewModel.uploadProfileImage(selectedImage: image)
                }
            }) {
                CropViewControllerWrapper(image: $selectedImage, completionHandler: { croppedImage in
                    self.selectedImage = croppedImage
                    self.showCropView = false
                })
                .ignoresSafeArea()
            }
        }
        .onAppear {
            viewModel.fetchUser()
            viewModel.fetchRecentPost()
        }
        .interactiveDismissDisabled()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .actionSheet(item: $currentActionSheet) { type in
            switch type {
            case .main:
                return ActionSheet(title: Text("Profile Options"), buttons: [
                    .default(Text("Change Profile Picture"), action: {
                        currentActionSheet = .changeProfile
                    }),
                    .destructive(Text("Log Out"), action: {
                        authViewModel.signout()
                    }),
                    .cancel()
                ])
            case .changeProfile:
                return ActionSheet(title: Text("Change Profile Picture"), buttons: [
                    .default(Text("Photo Library"), action: {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }),
                    .default(Text("Camera"), action: {
                        sourceType = .camera
                        showImagePicker = true
                    }),
                    .destructive(Text("Delete Profile Picture"), action: {
                        viewModel.deleteProfileImage()
                    }),
                    .cancel()
                ])
            }
        }
    }
}









//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
