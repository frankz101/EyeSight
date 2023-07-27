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
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var showImageCropper = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            //Header
            HStack {
                Text("Profile")
                    .font(.largeTitle).bold()
                Spacer()
                Button(action: {
                    showActionSheet = true
                }) {
                    if let urlString = viewModel.user?.profileImageURL, let url = URL(string: urlString) {
                        KFImage(url)
                            .resizable()
                            .frame(width: 72, height: 72)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 72, height: 72)
                    }
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Change Profile Picture"), buttons: [
                        .default(Text("Photo Library"), action: {
                            sourceType = .photoLibrary
                            showImagePicker = true
                        }),
                        .default(Text("Camera"), action: {
                            sourceType = .camera
                            showImagePicker = true
                        }),
                        .destructive(Text("Delete Profile Picture"), action: {
                            // Handle deletion
                            viewModel.deleteProfileImage()
                        }),
                        .cancel()
                    ])
                }
                .sheet(isPresented: $showImagePicker, onDismiss: {
                    if selectedImage != nil {
                        showImageCropper = true
                    }
                }) {
                    ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
                }
                .fullScreenCover(isPresented: $showImageCropper, onDismiss: {
                    // Handle the cropped image
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
            .padding(.horizontal, 16)
            .padding(.vertical,4)
            Spacer()
            Button {
                authViewModel.signout()
            } label: {
                Text("Sign Out")
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}



//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
