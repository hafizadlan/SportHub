//
//  SignUpView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var showingTerms = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, email, password, confirmPassword
    }
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        agreeToTerms
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 8) {
                            Text("Create Account")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Join SportHub and discover amazing activities")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Sign Up Form
                    VStack(spacing: 20) {
                        // Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            TextField("Enter your full name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                                .focused($focusedField, equals: .name)
                        }
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .focused($focusedField, equals: .email)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            SecureField("Create a password", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                                .focused($focusedField, equals: .password)
                            
                            if !password.isEmpty && password.count < 6 {
                                Text("Password must be at least 6 characters")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            SecureField("Confirm your password", text: $confirmPassword)
                                .textFieldStyle(CustomTextFieldStyle())
                                .focused($focusedField, equals: .confirmPassword)
                            
                            if !confirmPassword.isEmpty && password != confirmPassword {
                                Text("Passwords do not match")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Terms and Conditions
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: { agreeToTerms.toggle() }) {
                                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                    .font(.title2)
                                    .foregroundColor(agreeToTerms ? .blue : .secondary)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("I agree to the")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                +
                                Text(" Terms of Service")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .underline()
                                +
                                Text(" and")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                +
                                Text(" Privacy Policy")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .onTapGesture {
                                showingTerms = true
                            }
                            
                            Spacer()
                        }
                        
                        // Error Message
                        if let errorMessage = authManager.errorMessage {
                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        // Sign Up Button
                        Button(action: signUp) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "person.badge.plus")
                                }
                                Text("Create Account")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isFormValid ? Color.blue : Color.gray)
                            )
                        }
                        .disabled(authManager.isLoading || !isFormValid)
                    }
                    .padding(.horizontal, 24)
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("or")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                        
                        Rectangle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 24)
                    
                    // Social Sign Up
                    VStack(spacing: 16) {
                        // Apple Sign Up
                        Button(action: authManager.signInWithApple) {
                            HStack {
                                Image(systemName: "applelogo")
                                    .font(.title2)
                                Text("Sign up with Apple")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black)
                            )
                        }
                        .disabled(authManager.isLoading)
                        
                        // Google Sign Up
                        Button(action: authManager.signInWithGoogle) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.title2)
                                Text("Sign up with Google")
                                    .font(.headline)
                            }
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                        }
                        .disabled(authManager.isLoading)
                    }
                    .padding(.horizontal, 24)
                    
                    // Sign In Link
                    HStack {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button("Sign In") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Terms of Service", isPresented: $showingTerms) {
            Button("OK") { }
        } message: {
            Text("By using SportHub, you agree to our Terms of Service and Privacy Policy. We respect your privacy and are committed to protecting your personal information.")
        }
    }
    
    private func signUp() {
        focusedField = nil
        authManager.signUpWithEmail(email: email, password: password, name: name)
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthManager())
}
