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
                
            case .authenticated(let user):
                if dataManager.user != nil {
                    MainTabView()
                        .environmentObject(dataManager)
                } else if authManager.hasCompletedIntroduction {
                    OnboardingView()
                        .environmentObject(dataManager)
                } else {
                    AppIntroductionView()
                        .environmentObject(authManager)
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
