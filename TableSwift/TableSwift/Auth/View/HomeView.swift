//
//  HomeView.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Welcome, \(authViewModel.user?.email ?? "User")!")
                .font(.title)
                .padding()

            Button(action: {
                authViewModel.signOut()
            }) {
                Text("Sign Out")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
