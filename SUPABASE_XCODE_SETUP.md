# Supabase Xcode Setup Guide

## Step 1: Add Supabase Package to Xcode

1. Open `SportHub.xcodeproj` in Xcode
2. Select your project in the navigator
3. Go to the **Package Dependencies** tab
4. Click the **+** button
5. Enter this URL: `https://github.com/supabase/supabase-swift.git`
6. Click **Add Package**
7. Select **Supabase** and click **Add Package**

## Step 2: Update AppConfig.swift

Replace the placeholder values in `SportHub/Configuration/AppConfig.swift`:

```swift
struct AppConfig {
    static let supabaseURL = "https://your-project-id.supabase.co"
    static let supabaseAnonKey = "your-anon-key-here"
}
```

## Step 3: Build and Test

1. Build the project (Cmd+B)
2. Run the app (Cmd+R)
3. Test the authentication flow

## Troubleshooting

If you get build errors:
1. Clean build folder (Cmd+Shift+K)
2. Build again (Cmd+B)
3. Make sure the Supabase package is properly linked

## Next Steps

1. Set up your Supabase project
2. Run the SQL schema
3. Update the configuration with your credentials
4. Test the integration
