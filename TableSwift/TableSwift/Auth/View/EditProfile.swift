//
//  EditProfile.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import Foundation
import SwiftUI

struct EditProfileView: View {
    @State private var name: String
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    @State private var isUpdating = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel

    init(currentName: String) {
        _name = State(initialValue: currentName)
    }

    var body: some View {
        VStack {
            Button(action: { showImagePicker.toggle() }) {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(image: $profileImage)
            })

            TextField("Enter your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: updateProfile) {
                if isUpdating {
                    ProgressView()
                } else {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .padding()
    }

    private func updateProfile() {
        isUpdating = true
        authViewModel.updateUserProfile(name: name, profileImage: profileImage) { success in
            isUpdating = false
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
