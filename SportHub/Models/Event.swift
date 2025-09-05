//
//  Event.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import Foundation
import CoreLocation

struct Event: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let category: SportCategory
    let date: Date
    let time: String
    let location: String
    let coordinates: LocationCoordinate?
    let price: Double
    let isFree: Bool
    let maxParticipants: Int
    let currentParticipants: Int
    let organizer: Organizer
    let imageURL: String?
    let isIndoor: Bool
    let ageGroup: AgeGroup
    let isFamilyFriendly: Bool
    let contactInfo: String
    let requirements: String?
    
    var isAvailable: Bool {
        currentParticipants < maxParticipants
    }
    
    var spotsLeft: Int {
        maxParticipants - currentParticipants
    }
    
    var formattedPrice: String {
        if isFree {
            return "Free"
        } else {
            return String(format: "RM%.2f", price)
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

enum AgeGroup: String, CaseIterable, Codable {
    case all = "All Ages"
    case teens = "12-19"
    case youngAdults = "20-29"
    case adults = "30-40"
    case family = "Family Friendly"
}

struct LocationCoordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from coreLocation: CLLocationCoordinate2D) {
        self.latitude = coreLocation.latitude
        self.longitude = coreLocation.longitude
    }
    
    var coreLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
