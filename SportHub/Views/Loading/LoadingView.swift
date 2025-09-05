//
//  LoadingView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // App Logo/Icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    Image(systemName: "sportscourt.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                
                // App Name
                VStack(spacing: 8) {
                    Text("SportHub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.5), value: showContent)
                    
                    Text("Your Sports & Fitness Hub")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.7), value: showContent)
                }
                
                Spacer()
                
                // Loading indicator
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(1.0), value: showContent)
                    
                    Text("Loading...")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(1.2), value: showContent)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation {
                showContent = true
            }
        }
    }
}

#Preview {
    LoadingView()
}
