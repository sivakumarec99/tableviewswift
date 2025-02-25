//
//  ProfileView.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showEditProfile = false

    var body: some View {
        VStack {
            if let userProfile = authViewModel.userProfile {
                if let imageUrl = URL(string: userProfile.profileImageUrl), !userProfile.profileImageUrl.isEmpty {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                }

                Text(userProfile.name)
                    .font(.title)
                    .padding()

                Button(action: { showEditProfile.toggle() }) {
                    Text("Edit Profile")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .sheet(isPresented: $showEditProfile) {
                    EditProfileView(currentName: userProfile.name)
                        .environmentObject(authViewModel)
                }

                // 🔴 Logout Button
                Button(action: {
                    authViewModel.logout()
                }) {
                    Text("Logout")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            } else {
                Text("No user logged in")
                // 🔴 Logout Button
                Button(action: {
                    authViewModel.logout()
                }) {
                    Text("Logout")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .onAppear {
            authViewModel.fetchUserProfile()
        }
    }
}
