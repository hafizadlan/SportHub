//
//  DataManager.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import Foundation
import CoreLocation

class DataManager: ObservableObject {
    @Published var events: [Event] = []
    @Published var user: User?
    @Published var userActivities: [UserActivity] = []
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        let sampleOrganizers = [
            Organizer(
                name: "KL Sports Center",
                email: "info@klsports.com",
                phone: "+60123456789",
                profileImageURL: nil,
                isVerified: true,
                rating: 4.8,
                totalEvents: 45,
                joinDate: Date().addingTimeInterval(-86400 * 30),
                bio: "Premier sports facility in KL with professional coaches"
            ),
            Organizer(
                name: "Yoga Studio Malaysia",
                email: "hello@yogastudio.my",
                phone: "+60198765432",
                profileImageURL: nil,
                isVerified: true,
                rating: 4.9,
                totalEvents: 120,
                joinDate: Date().addingTimeInterval(-86400 * 90),
                bio: "Certified yoga instructors for all levels"
            ),
            Organizer(
                name: "Futsal United",
                email: "bookings@futsalunited.my",
                phone: "+60155512345",
                profileImageURL: nil,
                isVerified: false,
                rating: 4.5,
                totalEvents: 25,
                joinDate: Date().addingTimeInterval(-86400 * 15),
                bio: "Weekly futsal matches for all skill levels"
            )
        ]
        
        events = [
            Event(
                title: "Weekly Futsal Match",
                description: "Join our weekly futsal game! All skill levels welcome. Bring your friends and have fun!",
                category: .football,
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                time: "7:00 PM",
                location: "KL Sports Center, Jalan Ampang",
                coordinates: LocationCoordinate(latitude: 3.1390, longitude: 101.6869),
                price: 15.0,
                isFree: false,
                maxParticipants: 20,
                currentParticipants: 12,
                organizer: sampleOrganizers[0],
                imageURL: nil,
                isIndoor: true,
                ageGroup: .all,
                isFamilyFriendly: false,
                contactInfo: "+60123456789",
                requirements: "Bring your own shoes and water bottle"
            ),
            Event(
                title: "Morning Yoga Session",
                description: "Start your day with a peaceful yoga session. Perfect for beginners and experienced practitioners.",
                category: .yoga,
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                time: "7:00 AM",
                location: "Yoga Studio Malaysia, Mont Kiara",
                coordinates: LocationCoordinate(latitude: 3.1700, longitude: 101.6500),
                price: 0.0,
                isFree: true,
                maxParticipants: 15,
                currentParticipants: 8,
                organizer: sampleOrganizers[1],
                imageURL: nil,
                isIndoor: true,
                ageGroup: .all,
                isFamilyFriendly: true,
                contactInfo: "+60198765432",
                requirements: "Bring your own yoga mat"
            ),
            Event(
                title: "Badminton Tournament",
                description: "Monthly badminton tournament for intermediate players. Prizes for winners!",
                category: .badminton,
                date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                time: "2:00 PM",
                location: "Sports Complex, PJ",
                coordinates: LocationCoordinate(latitude: 3.1073, longitude: 101.6081),
                price: 25.0,
                isFree: false,
                maxParticipants: 32,
                currentParticipants: 28,
                organizer: sampleOrganizers[0],
                imageURL: nil,
                isIndoor: true,
                ageGroup: .youngAdults,
                isFamilyFriendly: false,
                contactInfo: "+60123456789",
                requirements: "Intermediate level required"
            ),
            Event(
                title: "Family Fun Run",
                description: "5K fun run for the whole family! Kids under 12 run free. Refreshments provided.",
                category: .running,
                date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
                time: "6:30 AM",
                location: "KLCC Park",
                coordinates: LocationCoordinate(latitude: 3.1579, longitude: 101.7116),
                price: 20.0,
                isFree: false,
                maxParticipants: 100,
                currentParticipants: 67,
                organizer: sampleOrganizers[1],
                imageURL: nil,
                isIndoor: false,
                ageGroup: .family,
                isFamilyFriendly: true,
                contactInfo: "+60198765432",
                requirements: "Comfortable running shoes"
            ),
            Event(
                title: "Muay Thai Training",
                description: "Learn the art of Muay Thai with certified instructors. All levels welcome.",
                category: .martialArts,
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                time: "8:00 PM",
                location: "Martial Arts Academy, Cheras",
                coordinates: LocationCoordinate(latitude: 3.1300, longitude: 101.7200),
                price: 30.0,
                isFree: false,
                maxParticipants: 12,
                currentParticipants: 6,
                organizer: sampleOrganizers[2],
                imageURL: nil,
                isIndoor: true,
                ageGroup: .adults,
                isFamilyFriendly: false,
                contactInfo: "+60155512345",
                requirements: "Wear comfortable workout clothes"
            )
        ]
        
        // Create sample user
        user = User(
            name: "Hafiz Adlan",
            email: "hafiz@example.com",
            profileImageURL: nil,
            interests: [.football, .badminton, .running],
            joinDate: Date().addingTimeInterval(-86400 * 7),
            totalEventsJoined: 3,
            isOrganizer: false
        )
    }
    
    func joinEvent(_ event: Event) {
        guard let user = user else { return }
        
        let activity = UserActivity(
            event: event,
            status: .going,
            joinDate: Date(),
            notes: nil
        )
        
        userActivities.append(activity)
        
        // Update event participants count
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = Event(
                title: event.title,
                description: event.description,
                category: event.category,
                date: event.date,
                time: event.time,
                location: event.location,
                coordinates: event.coordinates,
                price: event.price,
                isFree: event.isFree,
                maxParticipants: event.maxParticipants,
                currentParticipants: event.currentParticipants + 1,
                organizer: event.organizer,
                imageURL: event.imageURL,
                isIndoor: event.isIndoor,
                ageGroup: event.ageGroup,
                isFamilyFriendly: event.isFamilyFriendly,
                contactInfo: event.contactInfo,
                requirements: event.requirements
            )
        }
    }
    
    func saveEvent(_ event: Event) {
        // This would typically save to a backend
        events.append(event)
    }
    
    func filterEvents(by category: SportCategory? = nil, isFree: Bool? = nil, ageGroup: AgeGroup? = nil) -> [Event] {
        return events.filter { event in
            var matches = true
            
            if let category = category {
                matches = matches && event.category == category
            }
            
            if let isFree = isFree {
                matches = matches && event.isFree == isFree
            }
            
            if let ageGroup = ageGroup {
                matches = matches && event.ageGroup == ageGroup
            }
            
            return matches
        }
    }
}
