//
//  TableSwiftApp.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

@main
struct TableSwiftApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
        #if DEBUG
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authViewModel)
        }
    }
}

