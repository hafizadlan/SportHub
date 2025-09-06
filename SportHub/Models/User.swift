//
//  User.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String
    let profileImageURL: String?
    let interests: [SportCategory]
    let joinDate: Date
    let totalEventsJoined: Int
    let isOrganizer: Bool
    
    init(name: String, email: String, profileImageURL: String? = nil, interests: [SportCategory], joinDate: Date, totalEventsJoined: Int, isOrganizer: Bool) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.interests = interests
        self.joinDate = joinDate
        self.totalEventsJoined = totalEventsJoined
        self.isOrganizer = isOrganizer
    }
    
    var formattedJoinDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: joinDate)
    }
}

// UserActivity moved to separate file - UserActivity.swift
