//
//  CreateEventView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI
import MapKit

struct CreateEventView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: SportCategory = .football
    @State private var selectedDate = Date()
    @State private var time = ""
    @State private var location = ""
    @State private var price = ""
    @State private var isFree = false
    @State private var maxParticipants = ""
    @State private var selectedAgeGroup: AgeGroup = .all
    @State private var isIndoor = true
    @State private var isFamilyFriendly = false
    @State private var contactInfo = ""
    @State private var requirements = ""
    @State private var showingSuccessAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Event Information") {
                    TextField("Event Title", text: $title)
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(SportCategory.allCases) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                }
                
                Section("Date & Time") {
                    DatePicker("Event Date", selection: $selectedDate, displayedComponents: .date)
                    
                    TextField("Time (e.g., 7:00 PM)", text: $time)
                }
                
                Section("Location") {
                    TextField("Location", text: $location)
                    
                    Toggle("Indoor Event", isOn: $isIndoor)
                }
                
                Section("Pricing") {
                    Toggle("Free Event", isOn: $isFree)
                    
                    if !isFree {
                        TextField("Price (RM)", text: $price)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("Participants") {
                    TextField("Max Participants", text: $maxParticipants)
                        .keyboardType(.numberPad)
                    
                    Picker("Age Group", selection: $selectedAgeGroup) {
                        ForEach(AgeGroup.allCases, id: \.self) { ageGroup in
                            Text(ageGroup.rawValue).tag(ageGroup)
                        }
                    }
                    
                    Toggle("Family Friendly", isOn: $isFamilyFriendly)
                }
                
                Section("Contact & Requirements") {
                    TextField("Contact Information", text: $contactInfo)
                    
                    TextField("Requirements (Optional)", text: $requirements, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Create Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createEvent()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
        .alert("Event Created!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your event has been created successfully and is now visible to users.")
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty &&
        !description.isEmpty &&
        !time.isEmpty &&
        !location.isEmpty &&
        !contactInfo.isEmpty &&
        !maxParticipants.isEmpty &&
        Int(maxParticipants) != nil &&
        (!isFree ? !price.isEmpty && Double(price) != nil : true)
    }
    
    private func createEvent() {
        let newEvent = Event(
            title: title,
            description: description,
            category: selectedCategory,
            date: selectedDate,
            time: time,
            location: location,
            coordinates: nil, // Would be set with map integration
            price: isFree ? 0.0 : (Double(price) ?? 0.0),
            isFree: isFree,
            maxParticipants: Int(maxParticipants) ?? 10,
            currentParticipants: 0,
            organizer: dataManager.user?.isOrganizer == true ? 
                Organizer(
                    name: dataManager.user?.name ?? "Unknown",
                    email: dataManager.user?.email ?? "",
                    phone: contactInfo,
                    profileImageURL: nil,
                    isVerified: false,
                    rating: 5.0,
                    totalEvents: 1,
                    joinDate: Date(),
                    bio: nil
                ) : Organizer(
                    name: "Sample Organizer",
                    email: "sample@example.com",
                    phone: contactInfo,
                    profileImageURL: nil,
                    isVerified: false,
                    rating: 5.0,
                    totalEvents: 1,
                    joinDate: Date(),
                    bio: nil
                ),
            imageURL: nil,
            isIndoor: isIndoor,
            ageGroup: selectedAgeGroup,
            isFamilyFriendly: isFamilyFriendly,
            contactInfo: contactInfo,
            requirements: requirements.isEmpty ? nil : requirements
        )
        
        dataManager.saveEvent(newEvent)
        showingSuccessAlert = true
    }
}

#Preview {
    CreateEventView()
        .environmentObject(DataManager())
}
