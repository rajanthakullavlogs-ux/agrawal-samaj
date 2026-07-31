-- ============================================
-- Nepal Agrawal Samaj — Production Seed Data
-- ============================================

-- 1. SEED LOCATIONS
insert into locations (id, name, province, intro, office_address, latitude, longitude, total_members, status, contact_phone, contact_email)
values
  ('11111111-1111-1111-1111-111111111111', 'Kathmandu Central Chapter', 'Bagmati Province', 'Central chapter overseeing national initiatives, Samaj Bhawan administration, and cultural festivals.', 'Kamaladi, Kathmandu', 27.7172, 85.3240, 1248, 'active', '+977 1 4220000', 'kathmandu@agrawalsamaj.org.np'),
  ('22222222-2222-2222-2222-222222222222', 'Birgunj Border Chapter', 'Madhesh Province', 'Leading industrial and trade hub chapter with active business networking.', 'Main Road, Birgunj', 27.0126, 84.8770, 910, 'active', '+977 51 520000', 'birgunj@agrawalsamaj.org.np'),
  ('33333333-3333-3333-3333-333333333333', 'Biratnagar Branch Chapter', 'Koshi Province', 'Eastern zone chapter supporting local enterprise, educational scholarships, and healthcare camps.', 'Traffic Chowk, Biratnagar', 26.4525, 87.2718, 850, 'active', '+977 21 530000', 'biratnagar@agrawalsamaj.org.np'),
  ('44444444-4444-4444-4444-444444444444', 'Pokhara Regional Chapter', 'Gandaki Province', 'Scenic western chapter focused on youth engagement and heritage preservation.', 'Lakeside, Pokhara', 28.2096, 83.9856, 620, 'active', '+977 61 521111', 'pokhara@agrawalsamaj.org.np'),
  ('55555555-5555-5555-5555-555555555555', 'Butwal Industrial Chapter', 'Lumbini Province', 'Rapidly growing chapter driving community sports, health, and business networking.', 'Hospital Line, Butwal', 27.7006, 83.4484, 540, 'active', '+977 71 540222', 'butwal@agrawalsamaj.org.np')
on conflict (id) do update set
  name = excluded.name,
  total_members = excluded.total_members;

-- 2. SEED SAMPLE EVENTS
insert into events (id, location_id, title, description, category, event_date, event_time, venue, organized_by, status)
values
  ('a1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'National Agrawal Heritage Gala 2026', 'Annual nationwide gathering celebrating Agrawal culture, youth talent, and community honors.', 'CULTURAL', '2026-10-15', '17:00:00', 'Hotel Yak & Yeti, Kathmandu', 'Kathmandu Central Executive', 'upcoming'),
  ('a2222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Entrepreneurship & Trade Summit', 'High-level business networking summit for young entrepreneurs and established industrialists.', 'BUSINESS', '2026-10-22', '10:00:00', 'Samaj Hall, Kamaladi', 'Business Development Committee', 'upcoming'),
  ('a3333333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', 'Eastern Industrial Trade Expo', 'Trade and products exhibition highlighting Agrawal businesses across Koshi Province.', 'BUSINESS', '2026-11-02', '09:30:00', 'Trade Pavilion, Biratnagar', 'Biratnagar Chapter', 'upcoming'),
  ('a4444444-4444-4444-4444-444444444444', '55555555-5555-5555-5555-555555555555', 'Lumbini Youth Sports & Cultural Fest', 'Sports tournament, cricket derby, and cultural dance competitions.', 'YOUTH', '2026-11-18', '08:00:00', 'Municipal Stadium, Butwal', 'Youth Wing Butwal', 'upcoming')
on conflict (id) do update set
  title = excluded.title,
  status = excluded.status;

-- 3. SEED GALLERIES
insert into galleries (id, location_id, title, category, description, photo_count)
values
  ('g1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'Maha Shivaratri 2026 Celebrations', 'Cultural', 'Photos from the grand Shivaratri puja and community prasad distribution.', 124),
  ('g2222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333', 'Koshi Business Summit Highlights', 'Business', 'Keynote addresses, MOU signings, and networking sessions.', 185),
  ('g3333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444', 'Agrawal Heritage & Youth Festival', 'Heritage', 'Youth performances and traditional culinary showcases in Pokhara.', 512)
on conflict (id) do update set
  title = excluded.title,
  photo_count = excluded.photo_count;
