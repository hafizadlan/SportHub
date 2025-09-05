//
//  DiscoverView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI
import MapKit

struct DiscoverView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedCategory: SportCategory?
    @State private var selectedAgeGroup: AgeGroup?
    @State private var isFreeOnly = false
    @State private var showMap = false
    @State private var searchText = ""
    
    var filteredEvents: [Event] {
        dataManager.filterEvents(
            by: selectedCategory,
            isFree: isFreeOnly ? true : nil,
            ageGroup: selectedAgeGroup
        ).filter { event in
            if searchText.isEmpty {
                return true
            }
            return event.title.localizedCaseInsensitiveContains(searchText) ||
                   event.description.localizedCaseInsensitiveContains(searchText) ||
                   event.location.localizedCaseInsensitiveContains(searchText)
        }.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter Bar
                VStack(spacing: 12) {
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
                    
                    // Filter Controls
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterChip(
                                title: "All Categories",
                                isSelected: selectedCategory == nil
                            ) {
                                selectedCategory = nil
                            }
                            
                            ForEach(SportCategory.allCases) { category in
                                FilterChip(
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Additional Filters
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "Free Only",
                            isSelected: isFreeOnly
                        ) {
                            isFreeOnly.toggle()
                        }
                        
                        Menu {
                            ForEach(AgeGroup.allCases, id: \.self) { ageGroup in
                                Button(ageGroup.rawValue) {
                                    selectedAgeGroup = selectedAgeGroup == ageGroup ? nil : ageGroup
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedAgeGroup?.rawValue ?? "All Ages")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedAgeGroup != nil ? Color.blue : Color(.systemGray6))
                            )
                            .foregroundColor(selectedAgeGroup != nil ? .white : .primary)
                        }
                        
                        Spacer()
                        
                        Button(action: { showMap.toggle() }) {
                            Image(systemName: showMap ? "list.bullet" : "map")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Content
                if showMap {
                    MapView(events: filteredEvents)
                } else {
                    EventListView(events: filteredEvents)
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FilterChip: View {
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

struct MapView: View {
    let events: [Event]
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 3.1390, longitude: 101.6869),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: events) { event in
            MapAnnotation(coordinate: event.coordinates?.coreLocation ?? CLLocationCoordinate2D(latitude: 3.1390, longitude: 101.6869)) {
                NavigationLink(destination: EventDetailView(event: event)) {
                    MapPinView(event: event)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .ignoresSafeArea()
    }
}

struct MapPinView: View {
    let event: Event
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: event.category.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color(event.category.color))
                )
            
            Text(event.title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                )
        }
    }
}

struct EventListView: View {
    let events: [Event]
    
    var body: some View {
        if events.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("No events found")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Try adjusting your filters or search terms")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(events) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventListRow(event: event)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
    }
}

struct EventListRow: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 12) {
            // Event Image
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: event.category.icon)
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(event.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    if event.isFree {
                        Text("FREE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.green.opacity(0.1))
                            )
                    }
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.formattedDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
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
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

#Preview {
    DiscoverView()
        .environmentObject(DataManager())
}
