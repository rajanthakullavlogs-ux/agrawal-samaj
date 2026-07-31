-- ============================================
-- Nepal Agrawal Samaj — Initial Database Schema
-- ============================================

-- LOCATIONS
create table locations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  province text not null,
  intro text,
  office_address text,
  latitude numeric,
  longitude numeric,
  leader_profile_id uuid,
  total_members int default 0,
  status text default 'active',
  achievements text,
  contact_phone text,
  contact_email text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- PROFILES (1:1 with auth.users)
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text,
  phone text,
  address text,
  date_of_birth date,
  gender text,
  role text not null default 'member' check (role in ('member','location_admin','super_admin')),
  location_id uuid references locations(id),
  membership_type text default 'normal' check (membership_type in ('normal','business')),
  membership_status text default 'pending' check (membership_status in ('pending','active','inactive')),
  avatar_url text,
  created_at timestamptz default now()
);

alter table locations add constraint fk_leader foreign key (leader_profile_id) references profiles(id);

-- BUSINESS PROFILES
create table business_profiles (
  profile_id uuid primary key references profiles(id) on delete cascade,
  business_name text not null,
  business_type text,
  business_address text,
  registration_number text,
  business_phone text,
  business_email text
);

-- EVENTS
create table events (
  id uuid primary key default gen_random_uuid(),
  location_id uuid references locations(id),
  title text not null,
  description text,
  category text,
  event_date date not null,
  event_time time,
  venue text,
  organized_by text,
  poster_url text,
  status text default 'upcoming' check (status in ('upcoming','past','cancelled')),
  created_by uuid references profiles(id),
  created_at timestamptz default now()
);

-- EVENT REGISTRATIONS
create table event_registrations (
  id uuid primary key default gen_random_uuid(),
  event_id uuid references events(id) on delete cascade,
  profile_id uuid references profiles(id),
  registered_at timestamptz default now(),
  status text default 'confirmed',
  unique (event_id, profile_id)
);

-- GALLERIES + PHOTOS
create table galleries (
  id uuid primary key default gen_random_uuid(),
  location_id uuid references locations(id),
  event_id uuid references events(id),
  title text,
  category text,
  description text,
  cover_photo_url text,
  photo_count int default 0,
  created_at timestamptz default now()
);

create table gallery_photos (
  id uuid primary key default gen_random_uuid(),
  gallery_id uuid references galleries(id) on delete cascade,
  photo_url text not null,
  caption text,
  sort_order int default 0
);

-- CONTACT MESSAGES
create table contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null,
  message text not null,
  status text default 'new' check (status in ('new','read','resolved')),
  created_at timestamptz default now()
);

-- PAYMENTS
create table payments (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references profiles(id),
  purpose text check (purpose in ('membership','event')),
  reference_id uuid,
  amount numeric not null,
  gateway text check (gateway in ('esewa','khalti')),
  gateway_txn_id text,
  status text default 'pending' check (status in ('pending','success','failed')),
  created_at timestamptz default now()
);

-- ACTIVITY LOG
create table activity_log (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references profiles(id),
  location_id uuid references locations(id),
  action text not null,
  details jsonb,
  created_at timestamptz default now()
);

-- AGGREGATE STATS VIEW
create view org_stats as
select
  (select count(*) from profiles where membership_status = 'active') as active_members,
  (select count(*) from locations where status = 'active') as active_locations,
  (select count(*) from events where event_date >= current_date) as upcoming_events,
  (select count(*) from gallery_photos) as gallery_count;

-- SECURE ROLE PROMOTION FUNCTION
create function promote_to_location_admin(target_id uuid, loc_id uuid)
returns void
language plpgsql
security definer
as $$
begin
  if not exists (select 1 from profiles where id = auth.uid() and role = 'super_admin') then
    raise exception 'not authorized';
  end if;
  update profiles set role = 'location_admin', location_id = loc_id where id = target_id;
end;
$$;

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

alter table locations enable row level security;
alter table profiles enable row level security;
alter table business_profiles enable row level security;
alter table events enable row level security;
alter table event_registrations enable row level security;
alter table galleries enable row level security;
alter table gallery_photos enable row level security;
alter table contact_messages enable row level security;
alter table payments enable row level security;
alter table activity_log enable row level security;

-- PUBLIC READ POLICIES
create policy "public read locations" on locations for select using (true);
create policy "public read events" on events for select using (true);
create policy "public read galleries" on galleries for select using (true);
create policy "public read gallery_photos" on gallery_photos for select using (true);

-- PROFILES POLICIES
create policy "self select" on profiles for select using (auth.uid() = id);
create policy "self update" on profiles for update using (auth.uid() = id);
create policy "self insert" on profiles for insert with check (auth.uid() = id);
create policy "location admin manage members" on profiles for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'location_admin' and p.location_id = profiles.location_id)
);
create policy "super admin full access profiles" on profiles for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'super_admin')
);

-- EVENTS POLICIES
create policy "location admin manage events" on events for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'location_admin' and p.location_id = events.location_id)
);
create policy "super admin manage events" on events for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'super_admin')
);

-- LOCATIONS WRITE POLICIES
create policy "location admin manage own location" on locations for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'location_admin' and p.location_id = locations.id)
);
create policy "super admin manage locations" on locations for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'super_admin')
);

-- GALLERIES WRITE POLICIES
create policy "location admin manage galleries" on galleries for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'location_admin' and p.location_id = galleries.location_id)
);
create policy "super admin manage galleries" on galleries for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'super_admin')
);

-- GALLERY PHOTOS WRITE POLICIES
create policy "location admin manage gallery photos" on gallery_photos for all using (
  exists (
    select 1 from profiles p join galleries g on g.id = gallery_photos.gallery_id
    where p.id = auth.uid() and p.role = 'location_admin' and p.location_id = g.location_id
  )
);
create policy "super admin manage gallery photos" on gallery_photos for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'super_admin')
);

-- BUSINESS PROFILES POLICIES
create policy "self manage business profile" on business_profiles for all using (auth.uid() = profile_id);
create policy "location admin manage business profiles" on business_profiles for all using (
  exists (
    select 1 from profiles p join profiles bp on bp.id = business_profiles.profile_id
    where p.id = auth.uid() and p.role = 'location_admin' and p.location_id = bp.location_id
  )
);
create policy "super admin manage business profiles" on business_profiles for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'super_admin')
);

-- EVENT REGISTRATIONS
create policy "member manage own registration" on event_registrations for all using (auth.uid() = profile_id);
create policy "admin view registrations" on event_registrations for select using (
  exists (
    select 1 from profiles p join events e on e.id = event_registrations.event_id
    where p.id = auth.uid() and (p.role = 'super_admin' or (p.role = 'location_admin' and p.location_id = e.location_id))
  )
);

-- CONTACT MESSAGES
create policy "anyone can submit contact" on contact_messages for insert with check (true);
create policy "admins read contact" on contact_messages for select using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role in ('location_admin','super_admin'))
);

-- PAYMENTS
create policy "own payments" on payments for select using (auth.uid() = profile_id);
create policy "super admin payments" on payments for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'super_admin')
);

-- ACTIVITY LOG
create policy "location admin view activity" on activity_log for select using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'location_admin' and p.location_id = activity_log.location_id)
);
create policy "location admin insert activity" on activity_log for insert with check (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'location_admin' and p.location_id = activity_log.location_id)
);
create policy "super admin full access activity" on activity_log for all using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'super_admin')
);

-- ============================================
-- SEED DATA FOR INITIAL SETUP
-- ============================================

INSERT INTO locations (id, name, province, intro, office_address, total_members, status, contact_phone, contact_email)
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Kathmandu Chapter', 'Bagmati Province', 'Central chapter overseeing national initiatives, Samaj Bhawan administration, and cultural festivals.', 'Kamaladi, Kathmandu', 2100, 'active', '+977 1 4220000', 'kathmandu@agrawalsamaj.org.np'),
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'Birgunj Chapter', 'Madhesh Province', 'Leading industrial and trade hub chapter with active business networking and community welfare projects.', 'Main Road, Birgunj', 1450, 'active', '+977 51 520000', 'birgunj@agrawalsamaj.org.np'),
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'Biratnagar Chapter', 'Koshi Province', 'Eastern zone chapter supporting local enterprise, educational scholarships, and healthcare camps.', 'Traffic Chowk, Biratnagar', 980, 'active', '+977 21 530000', 'biratnagar@agrawalsamaj.org.np'),
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'Pokhara Chapter', 'Gandaki Province', 'Gandaki region chapter focused on tourism, youth activities, and preservation of Agrawal heritage.', 'New Road, Pokhara', 620, 'active', '+977 61 540000', 'pokhara@agrawalsamaj.org.np')
ON CONFLICT (id) DO NOTHING;

INSERT INTO events (id, title, description, category, event_date, event_time, venue, organized_by, status, location_id)
VALUES
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'Maharaja Agrasen Jayanti 2024', 'Join us for a grand cultural celebration, bhajans, prasad distribution, and honoring community elders.', 'Cultural', '2024-10-24', '4:00 PM', 'Hotel Annapurna, Kathmandu', 'Central Committee', 'upcoming', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b12', 'Business Networking Mixer', 'Empowering Agrawal entrepreneurs across Nepal with strategic partnerships, mentorship, and investment talks.', 'Social', '2024-11-12', '6:00 PM', 'Samaj Bhawan, Birgunj', 'Birgunj Branch', 'upcoming', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12'),
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b13', 'Annual Free Health Camp', 'Free health checkups, blood donation, and consultation by expert doctors for community members and public.', 'Social', '2024-12-05', '9:00 AM', 'Civil Hospital, Kathmandu', 'Youth Wing', 'upcoming', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')
ON CONFLICT (id) DO NOTHING;

INSERT INTO galleries (id, title, category, description, photo_count, location_id)
VALUES
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'Holi Milan Samaroh 2024', 'Cultural', 'Photos from the vibrant Holi celebrations in Kathmandu.', 12, 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c12', 'Business Summit 2023', 'Business', 'Highlights from the annual business leadership forum.', 8, 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12')
ON CONFLICT (id) DO NOTHING;

INSERT INTO gallery_photos (id, gallery_id, photo_url, caption, sort_order)
VALUES
  ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'https://picsum.photos/800/600?random=1', 'Opening Cultural Program', 1),
  ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d12', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'https://picsum.photos/800/600?random=2', 'Community Gathering', 2),
  ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d13', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'https://picsum.photos/800/600?random=3', 'Felicitation Ceremony', 3)
ON CONFLICT (id) DO NOTHING;

