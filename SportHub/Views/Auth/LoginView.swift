//
//  LoginView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    @State private var showingForgotPassword = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "sportscourt.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 8) {
                            Text("Welcome Back!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Sign in to continue your sports journey")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 40)
                    
                    // Login Form
                    VStack(spacing: 20) {
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
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                                .focused($focusedField, equals: .password)
                        }
                        
                        // Forgot Password
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                showingForgotPassword = true
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        
                        // Error Message
                        if let errorMessage = authManager.errorMessage {
                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        // Sign In Button
                        Button(action: signIn) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "arrow.right")
                                }
                                Text("Sign In")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                            )
                        }
                        .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
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
                    
                    // Social Sign In
                    VStack(spacing: 16) {
                        // Apple Sign In
                        Button(action: authManager.signInWithApple) {
                            HStack {
                                Image(systemName: "applelogo")
                                    .font(.title2)
                                Text("Continue with Apple")
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
                        
                        // Google Sign In
                        Button(action: authManager.signInWithGoogle) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.title2)
                                Text("Continue with Google")
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
                    
                    // Sign Up Link
                    HStack {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button("Sign Up") {
                            showingSignUp = true
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
        .alert("Forgot Password", isPresented: $showingForgotPassword) {
            TextField("Enter your email", text: $email)
            Button("Send Reset Link") {
                // Handle password reset
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("We'll send you a link to reset your password.")
        }
    }
    
    private func signIn() {
        focusedField = nil
        authManager.signInWithEmail(email: email, password: password)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
