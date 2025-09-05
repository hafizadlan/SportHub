//
//  SportCategory.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import Foundation

enum SportCategory: String, CaseIterable, Identifiable, Codable {
    case football = "Football"
    case badminton = "Badminton"
    case yoga = "Yoga"
    case gym = "Gym"
    case running = "Running"
    case martialArts = "Martial Arts"
    case family = "Family"
    case others = "Others"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .football: return "soccerball"
        case .badminton: return "figure.badminton"
        case .yoga: return "figure.yoga"
        case .gym: return "dumbbell"
        case .running: return "figure.run"
        case .martialArts: return "figure.martial.arts"
        case .family: return "figure.and.child.holdinghands"
        case .others: return "sportscourt"
        }
    }
    
    var color: String {
        switch self {
        case .football: return "green"
        case .badminton: return "blue"
        case .yoga: return "purple"
        case .gym: return "orange"
        case .running: return "red"
        case .martialArts: return "brown"
        case .family: return "pink"
        case .others: return "gray"
        }
    }
}
