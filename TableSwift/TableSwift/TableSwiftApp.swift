//
//  TableSwiftApp.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import SwiftUI
import FirebaseCore

@main
struct TableSwiftApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authViewModel)
        }
    }
}

