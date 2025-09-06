-- SportHub Database Schema for Supabase
-- Run this SQL in your Supabase SQL Editor

-- Enable Row Level Security
ALTER TABLE IF EXISTS auth.users ENABLE ROW LEVEL SECURITY;

-- Create users table
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    profile_image_url TEXT,
    interests TEXT[] DEFAULT '{}',
    join_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    total_events_joined INTEGER DEFAULT 0,
    is_organizer BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create organizers table
CREATE TABLE IF NOT EXISTS public.organizers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    profile_image_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    rating DECIMAL(3,2) DEFAULT 0.0,
    total_events INTEGER DEFAULT 0,
    join_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create events table
CREATE TABLE IF NOT EXISTS public.events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    time TEXT NOT NULL,
    location TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    price DECIMAL(10, 2) NOT NULL,
    is_free BOOLEAN DEFAULT FALSE,
    max_participants INTEGER NOT NULL,
    current_participants INTEGER DEFAULT 0,
    organizer_id UUID REFERENCES public.organizers(id) ON DELETE CASCADE,
    image_url TEXT,
    is_indoor BOOLEAN DEFAULT TRUE,
    age_group TEXT NOT NULL,
    is_family_friendly BOOLEAN DEFAULT FALSE,
    contact_info TEXT NOT NULL,
    requirements TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user_activities table
CREATE TABLE IF NOT EXISTS public.user_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    event_id UUID REFERENCES public.events(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'joined',
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    left_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, event_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_events_date ON public.events(date);
CREATE INDEX IF NOT EXISTS idx_events_category ON public.events(category);
CREATE INDEX IF NOT EXISTS idx_events_location ON public.events(location);
CREATE INDEX IF NOT EXISTS idx_user_activities_user_id ON public.user_activities(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activities_event_id ON public.user_activities(event_id);

-- Enable Row Level Security on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organizers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_activities ENABLE ROW LEVEL SECURITY;

-- Create RLS policies

-- Users can read their own data and public user data
CREATE POLICY "Users can read own data" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can read public user data" ON public.users
    FOR SELECT USING (true);

-- Users can update their own data
CREATE POLICY "Users can update own data" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Users can insert their own data
CREATE POLICY "Users can insert own data" ON public.users
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Events are readable by everyone
CREATE POLICY "Events are readable by everyone" ON public.events
    FOR SELECT USING (true);

-- Only organizers can create events
CREATE POLICY "Organizers can create events" ON public.events
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND is_organizer = true
        )
    );

-- Only event organizers can update their events
CREATE POLICY "Organizers can update own events" ON public.events
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND is_organizer = true
        )
    );

-- Only event organizers can delete their events
CREATE POLICY "Organizers can delete own events" ON public.events
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND is_organizer = true
        )
    );

-- User activities are readable by the user
CREATE POLICY "Users can read own activities" ON public.user_activities
    FOR SELECT USING (auth.uid() = user_id);

-- Users can create their own activities
CREATE POLICY "Users can create own activities" ON public.user_activities
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own activities
CREATE POLICY "Users can update own activities" ON public.user_activities
    FOR UPDATE USING (auth.uid() = user_id);

-- Users can delete their own activities
CREATE POLICY "Users can delete own activities" ON public.user_activities
    FOR DELETE USING (auth.uid() = user_id);

-- Organizers are readable by everyone
CREATE POLICY "Organizers are readable by everyone" ON public.organizers
    FOR SELECT USING (true);

-- Only verified organizers can create organizer profiles
CREATE POLICY "Verified users can create organizer profiles" ON public.organizers
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND is_organizer = true
        )
    );

-- Only organizers can update their own profiles
CREATE POLICY "Organizers can update own profiles" ON public.organizers
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND is_organizer = true
        )
    );

-- Create functions for updating timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_organizers_updated_at BEFORE UPDATE ON public.organizers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON public.events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_activities_updated_at BEFORE UPDATE ON public.user_activities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data
INSERT INTO public.organizers (id, name, email, phone, is_verified, rating, total_events, bio) VALUES
    ('550e8400-e29b-41d4-a716-446655440000', 'KL Sports Center', 'info@klsports.com', '+60123456789', true, 4.8, 45, 'Premier sports facility in Kuala Lumpur'),
    ('550e8400-e29b-41d4-a716-446655440001', 'Badminton Club Malaysia', 'contact@badmintonclub.my', '+60123456790', true, 4.6, 32, 'Professional badminton training and events'),
    ('550e8400-e29b-41d4-a716-446655440002', 'Yoga Studio KL', 'hello@yogastudiokl.com', '+60123456791', true, 4.9, 28, 'Mindful yoga practice in the heart of KL');

-- Insert sample events
INSERT INTO public.events (id, title, description, category, date, time, location, latitude, longitude, price, is_free, max_participants, current_participants, organizer_id, is_indoor, age_group, is_family_friendly, contact_info, requirements) VALUES
    ('660e8400-e29b-41d4-a716-446655440000', 'Futsal Friendly Match', 'Join our weekly futsal game! All skill levels welcome. Bring your friends and have fun!', 'football', NOW() + INTERVAL '2 days', '7:00 PM', 'KL Sports Center, Jalan Ampang', 3.1390, 101.6869, 15.00, false, 20, 12, '550e8400-e29b-41d4-a716-446655440000', true, 'teens', false, 'futsalclub@example.com', 'Indoor shoes required'),
    ('660e8400-e29b-41d4-a716-446655440001', 'Morning Yoga Session', 'Start your day with a peaceful yoga session. Perfect for beginners and experienced practitioners.', 'yoga', NOW() + INTERVAL '1 day', '7:00 AM', 'Yoga Studio KL, Bangsar', 3.1189, 101.6650, 25.00, false, 15, 8, '550e8400-e29b-41d4-a716-446655440002', true, 'adults', true, 'hello@yogastudiokl.com', 'Bring your own mat'),
    ('660e8400-e29b-41d4-a716-446655440002', 'Badminton Tournament', 'Monthly badminton tournament for all skill levels. Prizes for winners!', 'badminton', NOW() + INTERVAL '5 days', '2:00 PM', 'Badminton Club Malaysia, PJ', 3.1073, 101.6085, 20.00, false, 32, 18, '550e8400-e29b-41d4-a716-446655440001', true, 'adults', false, 'contact@badmintonclub.my', 'Bring your own racket');
