//
//  ContentView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    @StateObject private var dataManager = DataManager()
    
    var body: some View {
        Group {
            switch authManager.authState {
            case .loading:
                LoadingView()
                
            case .unauthenticated:
                LoginView()
                    .environmentObject(authManager)
                
            case .authenticated:
                if dataManager.user != nil {
                    MainTabView()
                        .environmentObject(dataManager)
                } else {
                    OnboardingView()
                        .environmentObject(dataManager)
                        .onAppear {
                            // Convert AuthUser to User for the app
                            if let authUser = authManager.currentUser {
                                let user = User(
                                    name: authUser.name,
                                    email: authUser.email,
                                    profileImageURL: authUser.profileImageURL,
                                    interests: [.football, .badminton, .running], // Default interests
                                    joinDate: authUser.createdAt,
                                    totalEventsJoined: 0,
                                    isOrganizer: false
                                )
                                dataManager.user = user
                            }
                        }
                }
                
            case .onboarding:
                OnboardingView()
                    .environmentObject(dataManager)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authManager.authState)
    }
}

#Preview {
    ContentView()
}
