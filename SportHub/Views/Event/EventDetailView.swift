//
//  EventDetailView.swift
//  SportHub
//
//  Created by Hafiz Adlan on 05/09/2025.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    let event: Event
    @EnvironmentObject var dataManager: DataManager
    @State private var showingShareSheet = false
    @State private var showingBookingSheet = false
    @State private var isJoined = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Event Image
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: event.category.icon)
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            
                            Text(event.category.rawValue)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    // Event Title and Price
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(event.formattedDate)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(event.formattedPrice)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(event.isFree ? .green : .blue)
                            
                            Text("per person")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Event Details
                    VStack(alignment: .leading, spacing: 12) {
                        DetailRow(icon: "location", title: "Location", value: event.location)
                        DetailRow(icon: "clock", title: "Time", value: event.time)
                        DetailRow(icon: "person.3", title: "Participants", value: "\(event.currentParticipants)/\(event.maxParticipants)")
                        DetailRow(icon: "figure.and.child.holdinghands", title: "Age Group", value: event.ageGroup.rawValue)
                        DetailRow(icon: "house", title: "Type", value: event.isIndoor ? "Indoor" : "Outdoor")
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About this event")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(event.description)
                            .font(.body)
                            .lineSpacing(4)
                    }
                    
                    // Requirements
                    if let requirements = event.requirements {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What to bring")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(requirements)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    
                    // Organizer Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Organizer")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.secondary)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(event.organizer.name)
                                        .font(.headline)
                                    
                                    if event.organizer.isVerified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.blue)
                                            .font(.caption)
                                    }
                                }
                                
                                HStack {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < Int(event.organizer.rating) ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                    }
                                    
                                    Text(String(format: "%.1f", event.organizer.rating))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Text("\(event.organizer.totalEvents) events organized")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Map
                    if let coordinates = event.coordinates {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Map(coordinateRegion: .constant(MKCoordinateRegion(
                                center: coordinates.coreLocation,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )))
                            .frame(height: 200)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                if event.isAvailable {
                    Button(action: { showingBookingSheet = true }) {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Join Event")
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
                } else {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "person.fill.xmark")
                            Text("Event Full")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray)
                        )
                    }
                    .disabled(true)
                }
                
                Button(action: { showingShareSheet = true }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Event")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .sheet(isPresented: $showingBookingSheet) {
            BookingView(event: event)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [event.title, event.description, event.location])
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}

struct BookingView: View {
    let event: Event
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    @State private var notes = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Join Event")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(event.title)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Date: \(event.formattedDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Additional Notes (Optional)")
                        .font(.headline)
                    
                    TextField("Any special requirements or notes...", text: $notes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: { showingConfirmation = true }) {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Confirm Booking")
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
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding()
            .navigationTitle("Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Booking Confirmed!", isPresented: $showingConfirmation) {
            Button("OK") {
                dataManager.joinEvent(event)
                dismiss()
            }
        } message: {
            Text("You have successfully joined this event. You'll receive a confirmation email shortly.")
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        EventDetailView(event: DataManager().events[0])
            .environmentObject(DataManager())
    }
}
