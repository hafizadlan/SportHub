# Supabase Setup for SportHub

This guide will help you set up Supabase as the backend for the SportHub iOS app.

## Prerequisites

1. A Supabase account (sign up at [supabase.com](https://supabase.com))
2. Xcode 15.0 or later
3. iOS 16.0 or later

## Step 1: Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - Name: `sport-hub`
   - Database Password: (choose a strong password)
   - Region: Choose the closest to your users
5. Click "Create new project"
6. Wait for the project to be set up (usually takes 1-2 minutes)

## Step 2: Get Your Project Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL** (looks like: `https://your-project-id.supabase.co`)
   - **anon public** key (starts with `eyJ...`)

## Step 3: Update App Configuration

1. Open `SportHub/Configuration/AppConfig.swift`
2. Replace the placeholder values:

```swift
struct AppConfig {
    static let supabaseURL = "https://your-project-id.supabase.co"
    static let supabaseAnonKey = "your-anon-key-here"
}
```

## Step 4: Set Up Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy and paste the entire contents of `supabase_schema.sql`
4. Click "Run" to execute the schema

This will create:
- `users` table for user profiles
- `organizers` table for event organizers
- `events` table for sports events
- `user_activities` table for tracking user participation
- Row Level Security (RLS) policies
- Sample data

## Step 5: Configure Authentication

1. In your Supabase dashboard, go to **Authentication** → **Settings**
2. Under **Site URL**, add your app's URL scheme (e.g., `sport-hub://`)
3. Under **Redirect URLs**, add your app's redirect URL
4. Enable **Email** authentication
5. Optionally enable **Apple** and **Google** authentication

## Step 6: Add Supabase SDK to Xcode

1. Open your project in Xcode
2. Go to **File** → **Add Package Dependencies**
3. Enter the URL: `https://github.com/supabase/supabase-swift.git`
4. Click **Add Package**
5. Select **Supabase** and click **Add Package**

## Step 7: Update Project Settings

1. In Xcode, select your project
2. Go to **Build Settings**
3. Search for "Swift Package Manager"
4. Make sure **Swift Package Manager** is enabled

## Step 8: Test the Integration

1. Build and run the app
2. Try signing up with a new account
3. Check the **Authentication** → **Users** section in Supabase to see the new user
4. Try creating an event and check the **Table Editor** → **events** table

## Database Schema Overview

### Users Table
- Stores user profiles and preferences
- Linked to Supabase Auth users
- Includes interests, join date, and organizer status

### Events Table
- Stores all sports events and activities
- Includes location, pricing, and participant limits
- Linked to organizers

### User Activities Table
- Tracks user participation in events
- Includes join/leave status and timestamps

### Organizers Table
- Stores organizer profiles and verification status
- Includes ratings and event counts

## Row Level Security (RLS)

The database uses RLS to ensure data security:
- Users can only access their own data
- Events are publicly readable
- Only organizers can create/update events
- User activities are private to each user

## Troubleshooting

### Common Issues

1. **Build Errors**: Make sure you've added the Supabase package correctly
2. **Authentication Errors**: Check your API keys and URL
3. **Database Errors**: Verify the schema was created correctly
4. **RLS Errors**: Check that your policies are set up correctly

### Debug Tips

1. Check the Supabase logs in the dashboard
2. Use the Supabase client in your app to test connections
3. Verify your API keys are correct
4. Check that your database schema matches the expected structure

## Next Steps

Once Supabase is set up:

1. **Real-time subscriptions**: Add real-time updates for events
2. **File storage**: Add image uploads for events and profiles
3. **Push notifications**: Integrate with Supabase Edge Functions
4. **Analytics**: Add user behavior tracking
5. **Advanced queries**: Add search and filtering capabilities

## Support

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Swift SDK](https://github.com/supabase/supabase-swift)
- [Supabase Community](https://github.com/supabase/supabase/discussions)
