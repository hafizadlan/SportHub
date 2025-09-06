//
//  AppIntroductionView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct AppIntroductionView: View {
    @State private var currentPage = 0
    @State private var isCompleted = false
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var dataManager = DataManager()
    
    let introductionPages = [
        IntroductionPage(
            title: "Discover Sports Activities",
            subtitle: "Find amazing sports events, classes, and activities near you",
            image: "magnifyingglass.circle.fill",
            color: .blue,
            description: "Browse through hundreds of sports activities including futsal, badminton, yoga, gym sessions, and more. Filter by location, price, and your interests."
        ),
        IntroductionPage(
            title: "Join & Book Events",
            subtitle: "Easily join events and book your spot with just a tap",
            image: "calendar.badge.plus",
            color: .green,
            description: "See real-time availability, book your spot instantly, and get confirmation notifications. Never miss out on your favorite activities again."
        ),
        IntroductionPage(
            title: "Track Your Activities",
            subtitle: "Keep track of all your sports activities in one place",
            image: "chart.line.uptrend.xyaxis",
            color: .orange,
            description: "View your upcoming activities, past events, and track your progress. See your activity history and discover new interests."
        ),
        IntroductionPage(
            title: "Connect with Community",
            subtitle: "Meet like-minded sports enthusiasts and make new friends",
            image: "person.3.fill",
            color: .purple,
            description: "Share activities with friends, join group events, and connect with the sports community. Build lasting friendships through shared interests."
        ),
        IntroductionPage(
            title: "Create Your Own Events",
            subtitle: "Organize and host your own sports activities",
            image: "plus.circle.fill",
            color: .red,
            description: "Become an organizer and create your own events. Set up futsal matches, yoga sessions, or any sports activity you love. Manage attendees and grow your community."
        )
    ]
    
    var body: some View {
        if isCompleted {
            OnboardingView()
                .environmentObject(dataManager)
        } else {
            VStack(spacing: 0) {
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(0..<introductionPages.count, id: \.self) { index in
                        IntroductionPageView(page: introductionPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Bottom Controls
                VStack(spacing: 24) {
                    // Page Indicator
                    HStack(spacing: 8) {
                        ForEach(0..<introductionPages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button("Previous") {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                        }
                        
                        Button(currentPage == introductionPages.count - 1 ? "Get Started" : "Next") {
                            if currentPage == introductionPages.count - 1 {
                                completeIntroduction()
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                    }
                    
                    // Skip Button
                    if currentPage < introductionPages.count - 1 {
                        Button("Skip Introduction") {
                            completeIntroduction()
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .background(Color(.systemBackground))
        }
    }
    
    private func completeIntroduction() {
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
        
        // Mark introduction as completed
        authManager.completeIntroduction()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            isCompleted = true
        }
    }
}

struct IntroductionPage {
    let title: String
    let subtitle: String
    let image: String
    let color: Color
    let description: String
}

struct IntroductionPageView: View {
    let page: IntroductionPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Feature Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.easeInOut(duration: 0.6), value: isAnimating)
                
                Image(systemName: page.image)
                    .font(.system(size: 60))
                    .foregroundColor(page.color)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.easeInOut(duration: 0.6).delay(0.1), value: isAnimating)
            }
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6).delay(0.2), value: isAnimating)
                
                Text(page.subtitle)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6).delay(0.3), value: isAnimating)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6).delay(0.4), value: isAnimating)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

#Preview {
    AppIntroductionView()
        .environmentObject(AuthManager())
}
