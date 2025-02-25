//
//  ContentView.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.user == nil {
                LoginView()
            } else {
                ProfileView()
            }
        }
        .onAppear {
            authViewModel.user = Auth.auth().currentUser
        }
    }
}

