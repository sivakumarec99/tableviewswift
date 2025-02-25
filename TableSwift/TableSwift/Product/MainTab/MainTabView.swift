//
//  MainTabView.swift
//  TableSwift
//
//  Created by Sivakumar R on 26/02/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            ProductListView()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Products")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}
