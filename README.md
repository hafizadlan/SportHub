# SportHub - Sports, Classes & Active Lifestyle Finder

A comprehensive iOS app built with SwiftUI that helps Malaysians discover, join, and book sports activities, classes, and active lifestyle events.

## 🏆 Features

### Core Features
- **Onboarding & Personalization**: User-friendly onboarding with interest selection
- **Event Discovery**: Browse sports activities with advanced filtering and map view
- **Event Details**: Comprehensive event information with booking functionality
- **User Dashboard**: Track upcoming and past activities
- **Social Features**: Share events and RSVP system
- **Organizer Tools**: Create and manage events

### Key Capabilities
- **Multi-Category Support**: Football, Badminton, Yoga, Gym, Running, Martial Arts, Family activities
- **Smart Filtering**: Filter by category, price, age group, location
- **Map Integration**: Apple MapKit integration for location-based discovery
- **Booking System**: Join events with confirmation and notes
- **User Management**: Profile management with interests and activity history
- **Organizer Features**: Create events with detailed information

## 🏗️ Architecture

### Data Models
- **Event**: Core event data with location, pricing, participants
- **User**: User profile with interests and activity history
- **Organizer**: Event organizer information with verification status
- **SportCategory**: Enum for different sports categories
- **UserActivity**: User's participation in events

### Views Structure
```
SportHub/
├── Models/
│   ├── Event.swift
│   ├── User.swift
│   ├── Organizer.swift
│   └── SportCategory.swift
├── Data/
│   └── DataManager.swift
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Discover/
│   │   └── DiscoverView.swift
│   ├── Event/
│   │   └── EventDetailView.swift
│   ├── Activities/
│   │   └── MyActivitiesView.swift
│   ├── Profile/
│   │   └── ProfileView.swift
│   └── Organizer/
│       └── CreateEventView.swift
└── MainTabView.swift
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `SportHub.xcodeproj` in Xcode
3. Build and run on iOS Simulator or device

### Sample Data
The app includes sample data for demonstration:
- 5 sample events across different categories
- Sample organizers with ratings and verification status
- Pre-configured user profile

## 📱 User Flow

### New User Journey
1. **Onboarding**: Welcome screens and interest selection
2. **Home**: Personalized feed with recommended events
3. **Discovery**: Browse and filter events by preferences
4. **Event Details**: View comprehensive event information
5. **Booking**: Join events with confirmation
6. **My Activities**: Track participation history

### Organizer Journey
1. **Profile**: Access organizer tools
2. **Create Event**: Comprehensive event creation form
3. **Manage**: Track event participants and updates

## 🎨 Design Features

### UI/UX Highlights
- **Modern SwiftUI Design**: Clean, intuitive interface
- **Color-Coded Categories**: Visual distinction for different sports
- **Responsive Layout**: Adapts to different screen sizes
- **Accessibility**: VoiceOver support and semantic labels
- **Smooth Animations**: Engaging transitions and interactions

### Visual Elements
- **Category Icons**: SF Symbols for each sport category
- **Status Badges**: Clear visual indicators for event status
- **Map Integration**: Interactive location visualization
- **Card-Based Layout**: Easy-to-scan event information

## 🔧 Technical Implementation

### Key Technologies
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for data flow
- **MapKit**: Location services and map display
- **Core Location**: GPS and location permissions

### Data Management
- **ObservableObject**: Reactive data binding
- **Sample Data**: Pre-loaded events for demonstration
- **State Management**: Local state with @State and @StateObject

### Future Enhancements
- **Backend Integration**: Firebase/Supabase for real data
- **Push Notifications**: Event reminders and updates
- **Payment Integration**: In-app payment processing
- **Social Features**: User reviews and ratings
- **Gamification**: Points and achievement system

## 📊 Sample Data Structure

### Events Include
- **Football**: Weekly futsal matches
- **Yoga**: Morning yoga sessions
- **Badminton**: Tournament events
- **Running**: Family fun runs
- **Martial Arts**: Muay Thai training

### Event Details
- Title, description, and category
- Date, time, and location
- Pricing and participant limits
- Organizer information
- Requirements and contact details

## 🎯 Target Audience

### Primary Users
- **Teens (12-19)**: Discover affordable sports activities
- **Young Adults (20-29)**: Fitness enthusiasts and hobby sports
- **Adults (30-40)**: Family-friendly activities and work-life balance

### Use Cases
- Finding local sports events
- Booking court time and classes
- Discovering new activities
- Connecting with sports communities
- Organizing group activities

## 🔮 Future Roadmap

### Phase 2 Features
- **Payment Integration**: TNG eWallet, GrabPay, FPX
- **Real-time Updates**: Live event status and notifications
- **Social Features**: User reviews and community building
- **Advanced Search**: AI-powered recommendations

### Phase 3 Features
- **Gamification**: Points, badges, and achievements
- **Team Formation**: Find players for team sports
- **Family Accounts**: Parent-child account management
- **Partnerships**: Integration with sports venues and gyms

## 📄 License

This project is created for educational and demonstration purposes. All rights reserved.

## 🤝 Contributing

This is a demonstration project. For production use, consider:
- Adding proper error handling
- Implementing backend integration
- Adding comprehensive testing
- Following iOS Human Interface Guidelines
- Implementing accessibility features

## 📞 Support

For questions or support regarding this demonstration app, please refer to the code comments and documentation within the project files.

---

**SportHub** - Bringing Malaysians together through sports and active lifestyle! 🏃‍♂️⚽🏸
