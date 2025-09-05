//
//  AuthUser.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import Foundation

struct AuthUser: Identifiable, Codable {
    let id: UUID
    let email: String
    let name: String
    let profileImageURL: String?
    let authProvider: AuthProvider
    let isEmailVerified: Bool
    let createdAt: Date
    let lastLoginAt: Date
    
    init(email: String, name: String, profileImageURL: String? = nil, authProvider: AuthProvider, isEmailVerified: Bool = false) {
        self.id = UUID()
        self.email = email
        self.name = name
        self.profileImageURL = profileImageURL
        self.authProvider = authProvider
        self.isEmailVerified = isEmailVerified
        self.createdAt = Date()
        self.lastLoginAt = Date()
    }
}

enum AuthProvider: String, CaseIterable, Codable {
    case email = "email"
    case apple = "apple"
    case google = "google"
    case facebook = "facebook"
    
    var displayName: String {
        switch self {
        case .email: return "Email"
        case .apple: return "Apple"
        case .google: return "Google"
        case .facebook: return "Facebook"
        }
    }
    
    var icon: String {
        switch self {
        case .email: return "envelope.fill"
        case .apple: return "applelogo"
        case .google: return "globe"
        case .facebook: return "f.circle.fill"
        }
    }
}

enum AuthState: Equatable {
    case loading
    case unauthenticated
    case authenticated(AuthUser)
    case onboarding
    
    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.unauthenticated, .unauthenticated), (.onboarding, .onboarding):
            return true
        case (.authenticated(let lhsUser), .authenticated(let rhsUser)):
            return lhsUser.id == rhsUser.id
        default:
            return false
        }
    }
}
