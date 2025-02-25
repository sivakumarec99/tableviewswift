//
//  ContentView.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import SwiftUI
import FirebaseAuth

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if authViewModel.isAuthenticated {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

