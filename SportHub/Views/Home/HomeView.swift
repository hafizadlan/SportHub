//
//  HomeView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedCategory: SportCategory?
    @State private var searchText = ""
    
    var filteredEvents: [Event] {
        var events = dataManager.events
        
        if let category = selectedCategory {
            events = events.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            events = events.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return events.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Welcome Section
                    if let user = dataManager.user {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome back, \(user.name)!")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Ready to find your next activity?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search activities...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryFilterButton(
                                title: "All",
                                isSelected: selectedCategory == nil
                            ) {
                                selectedCategory = nil
                            }
                            
                            ForEach(SportCategory.allCases) { category in
                                CategoryFilterButton(
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Quick Stats
                    if let user = dataManager.user {
                        HStack(spacing: 20) {
                            QuickStatCard(
                                title: "Events Joined",
                                value: "\(user.totalEventsJoined)",
                                icon: "calendar.badge.checkmark",
                                color: .blue
                            )
                            
                            QuickStatCard(
                                title: "This Week",
                                value: "\(upcomingEventsThisWeek)",
                                icon: "clock",
                                color: .green
                            )
                            
                            QuickStatCard(
                                title: "Interests",
                                value: "\(user.interests.count)",
                                icon: "heart.fill",
                                color: .red
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Featured Events
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Featured Events")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            NavigationLink("See All") {
                                DiscoverView()
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Array(filteredEvents.prefix(5))) { event in
                                    NavigationLink(destination: EventDetailView(event: event)) {
                                        EventCard(event: event)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Recent Activities
                    if !dataManager.userActivities.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Your Recent Activities")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                NavigationLink("View All") {
                                    MyActivitiesView()
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(Array(dataManager.userActivities.prefix(3))) { activity in
                                    ActivityRow(activity: activity)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("SportHub")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var upcomingEventsThisWeek: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekFromNow = calendar.date(byAdding: .weekOfYear, value: 1, to: now) ?? now
        
        return filteredEvents.filter { event in
            event.date >= now && event.date <= weekFromNow
        }.count
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Event Image Placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(height: 120)
                .overlay(
                    Image(systemName: event.category.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(event.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(event.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(event.formattedPrice)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(event.isFree ? .green : .blue)
                    
                    Spacer()
                    
                    Text("\(event.spotsLeft) spots left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct ActivityRow: View {
    let activity: UserActivity
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: activity.event.category.icon)
                .font(.title2)
                .foregroundColor(Color(activity.event.category.color))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color(activity.event.category.color).opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.event.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(activity.event.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(activity.status.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(statusColor(activity.status).opacity(0.2))
                )
                .foregroundColor(statusColor(activity.status))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private func statusColor(_ status: ActivityStatus) -> Color {
        switch status {
        case .interested: return .orange
        case .going: return .green
        case .completed: return .blue
        case .cancelled: return .red
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(DataManager())
}
