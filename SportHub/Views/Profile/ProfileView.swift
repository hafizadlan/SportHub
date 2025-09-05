//
//  ProfileView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var authManager: AuthManager
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    @State private var showingCreateEvent = false
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Profile Picture
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)
                            )
                        
                        VStack(spacing: 4) {
                            Text(dataManager.user?.name ?? "User")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(dataManager.user?.email ?? "user@example.com")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Member since \(dataManager.user?.formattedJoinDate ?? "")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Button("Edit Profile") {
                            showingEditProfile = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Stats Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Activity Stats")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 20) {
                            StatCard(
                                title: "Events Joined",
                                value: "\(dataManager.user?.totalEventsJoined ?? 0)",
                                icon: "calendar.badge.checkmark",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "This Month",
                                value: "\(eventsThisMonth)",
                                icon: "calendar",
                                color: .green
                            )
                            
                            StatCard(
                                title: "Interests",
                                value: "\(dataManager.user?.interests.count ?? 0)",
                                icon: "heart.fill",
                                color: .red
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Interests Section
                    if let interests = dataManager.user?.interests, !interests.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Interests")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                ForEach(interests) { interest in
                                    InterestChip(category: interest)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                        )
                    }
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        MenuRow(
                            icon: "calendar.badge.plus",
                            title: "Create Event",
                            subtitle: "Organize your own activity",
                            action: { showingCreateEvent = true }
                        )
                        
                        Divider()
                        
                        MenuRow(
                            icon: "star.fill",
                            title: "Favorites",
                            subtitle: "Your saved activities",
                            action: {}
                        )
                        
                        Divider()
                        
                        MenuRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Manage your preferences",
                            action: {}
                        )
                        
                        Divider()
                        
                        MenuRow(
                            icon: "gearshape.fill",
                            title: "Settings",
                            subtitle: "App preferences and account",
                            action: { showingSettings = true }
                        )
                        
                        Divider()
                        
                        MenuRow(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            subtitle: "Get help and contact us",
                            action: {}
                        )
                        
                        Divider()
                        
                        MenuRow(
                            icon: "info.circle.fill",
                            title: "About",
                            subtitle: "App version and info",
                            action: {}
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Sign Out Button
                    Button(action: { showingSignOutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showingCreateEvent) {
            CreateEventView()
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authManager.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
    
    private var eventsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now
        
        return dataManager.userActivities.filter { activity in
            activity.joinDate >= startOfMonth && activity.joinDate < endOfMonth
        }.count
    }
}

struct StatCard: View {
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
    }
}

struct InterestChip: View {
    let category: SportCategory
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: category.icon)
                .font(.caption)
                .foregroundColor(.white)
            
            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(category.color))
        )
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Notifications") {
                    HStack {
                        Text("Push Notifications")
                        Spacer()
                        Toggle("", isOn: .constant(true))
                    }
                    
                    HStack {
                        Text("Email Notifications")
                        Spacer()
                        Toggle("", isOn: .constant(true))
                    }
                }
                
                Section("Privacy") {
                    NavigationLink("Privacy Policy") {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink("Terms of Service") {
                        Text("Terms of Service")
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var name = ""
    @State private var email = ""
    @State private var selectedInterests: Set<SportCategory> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                }
                
                Section("Interests") {
                    ForEach(SportCategory.allCases) { category in
                        HStack {
                            Image(systemName: category.icon)
                                .foregroundColor(Color(category.color))
                                .frame(width: 24)
                            
                            Text(category.rawValue)
                            
                            Spacer()
                            
                            if selectedInterests.contains(category) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedInterests.contains(category) {
                                selectedInterests.remove(category)
                            } else {
                                selectedInterests.insert(category)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save profile changes
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let user = dataManager.user {
                name = user.name
                email = user.email
                selectedInterests = Set(user.interests)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(DataManager())
}
