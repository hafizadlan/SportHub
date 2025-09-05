//
//  OnboardingView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var selectedInterests: Set<SportCategory> = []
    @State private var isCompleted = false
    @EnvironmentObject var dataManager: DataManager
    
    let pages = [
        OnboardingPage(
            title: "Welcome to SportHub",
            subtitle: "Discover, join, and book sports activities in Malaysia",
            image: "sportscourt.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Find Your Sport",
            subtitle: "From futsal to yoga, discover activities that match your interests",
            image: "figure.run",
            color: .green
        ),
        OnboardingPage(
            title: "Join the Community",
            subtitle: "Connect with fellow sports enthusiasts and make new friends",
            image: "person.3.fill",
            color: .orange
        )
    ]
    
    var body: some View {
        if isCompleted {
            MainTabView()
        } else {
            VStack(spacing: 0) {
                if currentPage < pages.count {
                    OnboardingPageView(page: pages[currentPage])
                } else {
                    InterestSelectionView(selectedInterests: $selectedInterests)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    if currentPage < pages.count {
                        PageIndicator(currentPage: currentPage, totalPages: pages.count)
                        
                        HStack {
                            if currentPage > 0 {
                                Button("Previous") {
                                    withAnimation {
                                        currentPage -= 1
                                    }
                                }
                                .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                                withAnimation {
                                    if currentPage == pages.count - 1 {
                                        currentPage += 1
                                    } else {
                                        currentPage += 1
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        Button("Complete Setup") {
                            completeOnboarding()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selectedInterests.isEmpty)
                    }
                }
                .padding()
            }
        }
    }
    
    private func completeOnboarding() {
        // Update user interests
        if var user = dataManager.user {
            user = User(
                name: user.name,
                email: user.email,
                profileImageURL: user.profileImageURL,
                interests: Array(selectedInterests),
                joinDate: user.joinDate,
                totalEventsJoined: user.totalEventsJoined,
                isOrganizer: user.isOrganizer
            )
            dataManager.user = user
        }
        
        withAnimation {
            isCompleted = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let image: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 120))
                .foregroundColor(page.color)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

struct InterestSelectionView: View {
    @Binding var selectedInterests: Set<SportCategory>
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text("What are you interested in?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Select your favorite sports and activities")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(SportCategory.allCases) { category in
                    InterestCard(
                        category: category,
                        isSelected: selectedInterests.contains(category)
                    ) {
                        if selectedInterests.contains(category) {
                            selectedInterests.remove(category)
                        } else {
                            selectedInterests.insert(category)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct InterestCard: View {
    let category: SportCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 40))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(category.rawValue)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(category.color) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(category.color) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.primary : Color.secondary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(DataManager())
}
