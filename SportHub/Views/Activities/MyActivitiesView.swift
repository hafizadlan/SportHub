//
//  MyActivitiesView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct MyActivitiesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0
    
    var upcomingActivities: [UserActivity] {
        dataManager.userActivities.filter { activity in
            activity.event.date > Date() && activity.status != .cancelled
        }.sorted { $0.event.date < $1.event.date }
    }
    
    var pastActivities: [UserActivity] {
        dataManager.userActivities.filter { activity in
            activity.event.date <= Date() || activity.status == .cancelled
        }.sorted { $0.event.date > $1.event.date }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Selector
                Picker("Activity Type", selection: $selectedTab) {
                    Text("Upcoming").tag(0)
                    Text("Past").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content
                if selectedTab == 0 {
                    UpcomingActivitiesView(activities: upcomingActivities)
                } else {
                    PastActivitiesView(activities: pastActivities)
                }
            }
            .navigationTitle("My Activities")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct UpcomingActivitiesView: View {
    let activities: [UserActivity]
    
    var body: some View {
        if activities.isEmpty {
            EmptyStateView(
                icon: "calendar.badge.clock",
                title: "No Upcoming Activities",
                message: "You haven't joined any upcoming events yet. Discover activities that interest you!"
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(activities) { activity in
                        ActivityDetailCard(activity: activity)
                    }
                }
                .padding()
            }
        }
    }
}

struct PastActivitiesView: View {
    let activities: [UserActivity]
    
    var body: some View {
        if activities.isEmpty {
            EmptyStateView(
                icon: "clock.arrow.circlepath",
                title: "No Past Activities",
                message: "Your completed activities will appear here."
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(activities) { activity in
                        ActivityDetailCard(activity: activity)
                    }
                }
                .padding()
            }
        }
    }
}

struct ActivityDetailCard: View {
    let activity: UserActivity
    @State private var showingEventDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.event.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(activity.event.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    StatusBadge(status: activity.status)
                    
                    Text(activity.event.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Event Details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(activity.event.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(activity.event.time)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(activity.event.formattedPrice)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Notes
            if let notes = activity.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Notes")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text(notes)
                        .font(.subheadline)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                }
            }
            
            // Actions
            HStack(spacing: 12) {
                Button(action: { showingEventDetail = true }) {
                    HStack {
                        Image(systemName: "eye")
                        Text("View Details")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
                
                if activity.status == .going {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 1)
                        )
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .sheet(isPresented: $showingEventDetail) {
            EventDetailView(event: activity.event)
        }
    }
}

struct StatusBadge: View {
    let status: ActivityStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(statusColor.opacity(0.2))
            )
            .foregroundColor(statusColor)
    }
    
    private var statusColor: Color {
        switch status {
        case .interested: return .orange
        case .going: return .green
        case .completed: return .blue
        case .cancelled: return .red
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            NavigationLink(destination: DiscoverView()) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Discover Activities")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    MyActivitiesView()
        .environmentObject(DataManager())
}
