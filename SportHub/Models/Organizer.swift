//
//  Organizer.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import Foundation

struct Organizer: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String
    let phone: String
    let profileImageURL: String?
    let isVerified: Bool
    let rating: Double
    let totalEvents: Int
    let joinDate: Date
    let bio: String?
    
    init(name: String, email: String, phone: String, profileImageURL: String? = nil, isVerified: Bool, rating: Double, totalEvents: Int, joinDate: Date, bio: String? = nil) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.phone = phone
        self.profileImageURL = profileImageURL
        self.isVerified = isVerified
        self.rating = rating
        self.totalEvents = totalEvents
        self.joinDate = joinDate
        self.bio = bio
    }
    
    var formattedJoinDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: joinDate)
    }
}
