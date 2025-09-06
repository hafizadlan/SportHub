//
//  AuthManager.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import Foundation
import Combine

class AuthManager: ObservableObject {
    @Published var authState: AuthState = .loading
    @Published var currentUser: AuthUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasCompletedIntroduction = false
    
    private var cancellables = Set<AnyCancellable>()
    		
    init() {
        // Simulate loading time
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkAuthState()
        }
        loadIntroductionStatus()
    }
    
    private func checkAuthState() {
        // In a real app, this would check for stored authentication tokens
        // For demo purposes, we'll simulate checking stored auth
        if let savedUser = getSavedUser() {
            self.authState = .authenticated(savedUser)
            self.currentUser = savedUser
        } else {
            self.authState = .unauthenticated
        }
    }
    
    func signInWithEmail(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // In a real app, this would make an API call
            if self.validateCredentials(email: email, password: password) {
                let user = AuthUser(
                    email: email,
                    name: self.extractNameFromEmail(email),
                    authProvider: .email,
                    isEmailVerified: true
                )
                self.saveUser(user)
                self.authState = .authenticated(user)
                self.currentUser = user
            } else {
                self.errorMessage = "Invalid email or password"
            }
            self.isLoading = false
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String) {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // In a real app, this would make an API call
            if self.validateEmail(email) {
                let user = AuthUser(
                    email: email,
                    name: name,
                    authProvider: .email,
                    isEmailVerified: false
                )
                self.saveUser(user)
                self.authState = .authenticated(user)
                self.currentUser = user
            } else {
                self.errorMessage = "Please enter a valid email address"
            }
            self.isLoading = false
        }
    }
    
    func signInWithApple() {
        isLoading = true
        errorMessage = nil
        
        // Simulate Apple Sign In
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let user = AuthUser(
                email: "hafiz@icloud.com",
                name: "Hafiz Adlan",
                profileImageURL: nil,
                authProvider: .apple,
                isEmailVerified: true
            )
            self.saveUser(user)
            self.authState = .authenticated(user)
            self.currentUser = user
            self.isLoading = false
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        // Simulate Google Sign In
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let user = AuthUser(
                email: "hafiz@gmail.com",
                name: "Hafiz Adlan",
                profileImageURL: nil,
                authProvider: .google,
                isEmailVerified: true
            )
            self.saveUser(user)
            self.authState = .authenticated(user)
            self.currentUser = user
            self.isLoading = false
        }
    }
    
    func signOut() {
        currentUser = nil
        authState = .unauthenticated
        hasCompletedIntroduction = false
        clearSavedUser()
        clearIntroductionStatus()
    }
    
    func completeOnboarding() {
        authState = .onboarding
    }
    
    func completeIntroduction() {
        hasCompletedIntroduction = true
        saveIntroductionStatus()
    }
    
    // MARK: - Private Methods
    
    private func validateCredentials(email: String, password: String) -> Bool {
        // Simple validation for demo
        return email.contains("@") && password.count >= 6
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func extractNameFromEmail(_ email: String) -> String {
        let components = email.components(separatedBy: "@")
        return components.first?.capitalized ?? "User"
    }
    
    private func saveUser(_ user: AuthUser) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "saved_user")
        }
    }
    
    private func getSavedUser() -> AuthUser? {
        guard let data = UserDefaults.standard.data(forKey: "saved_user"),
              let user = try? JSONDecoder().decode(AuthUser.self, from: data) else {
            return nil
        }
        return user
    }
    
    private func clearSavedUser() {
        UserDefaults.standard.removeObject(forKey: "saved_user")
    }
    
    private func saveIntroductionStatus() {
        UserDefaults.standard.set(hasCompletedIntroduction, forKey: "has_completed_introduction")
    }
    
    private func loadIntroductionStatus() {
        hasCompletedIntroduction = UserDefaults.standard.bool(forKey: "has_completed_introduction")
    }
    
    private func clearIntroductionStatus() {
        UserDefaults.standard.removeObject(forKey: "has_completed_introduction")
    }
}
