//
//  AuthView.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    @State private var isLoginMode = true
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if !isLoginMode {
                Button(action: {
                    showImagePicker.toggle()
                }) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }
                }
                .sheet(isPresented: $showImagePicker, content: {
                    ImagePicker(image: $profileImage)
                })
            }

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .opacity(isLoginMode ? 0 : 1)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if isLoginMode {
                    authViewModel.signIn(email: email, password: password) { success in }
                } else {
                    authViewModel.signUp(email: email, password: password, name: name, profileImage: profileImage) { success in }
                }
            }) {
                Text(isLoginMode ? "Login" : "Sign Up")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: { isLoginMode.toggle() }) {
                Text(isLoginMode ? "Need an account? Sign Up" : "Already have an account? Login")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
