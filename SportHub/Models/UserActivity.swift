//
//  UserActivity.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import Foundation

struct UserActivity: Identifiable, Codable {
    let id = UUID()
    let event: Event
    let status: ActivityStatus
    let joinDate: Date
    let notes: String?
    
    init(event: Event, status: ActivityStatus, joinDate: Date, notes: String? = nil) {
        self.event = event
        self.status = status
        self.joinDate = joinDate
        self.notes = notes
    }
}

enum ActivityStatus: String, CaseIterable, Codable {
    case interested = "Interested"
    case going = "Going"
    case completed = "Completed"
    case cancelled = "Cancelled"
}
