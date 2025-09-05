//
//  MainTabView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager()
    @StateObject private var authManager = AuthManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            DiscoverView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
                .tag(1)
            
            MyActivitiesView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("My Activities")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .environmentObject(dataManager)
        .environmentObject(authManager)
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
