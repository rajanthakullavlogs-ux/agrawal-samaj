# Nepal Agrawal Samaj — Complete Features & Page Documentation

> **Application Name**: Nepal Agrawal Samaj (नेपाल अग्रवाल समाज)  
> **Tagline**: Heritage & Unity | Unity • Culture • Service  
> **Tech Stack**: Flutter (Cross-platform Web / Mobile / Desktop), Riverpod State Management, GoRouter Navigation, Supabase (Auth, Postgres DB, Storage, Realtime), Custom Design System.

---

## 📐 Table of Contents

1. [Executive Summary & App Architecture](#1-executive-summary--app-architecture)
2. [Role-Based Access Control (RBAC) Matrix](#2-role-based-access-control-rbac-matrix)
3. [Section A: Public & Community Pages (Visitor View)](#3-section-a-public--community-pages-visitor-view)
   - [01. Home Screen (`/`)](#01-home-screen-)
   - [02. About Us Screen (`/about`)](#02-about-us-screen-about)
   - [03. Events Directory Screen (`/events`)](#03-events-directory-screen-events)
   - [04. Event Detail & RSVP Screen (`/events/:id`)](#04-event-detail--rsvp-screen-eventsid)
   - [05. Photo & Media Gallery (`/gallery`)](#05-photo--media-gallery-gallery)
   - [06. Gallery Detail Lightbox (`/gallery/:id`)](#06-gallery-detail-lightbox-galleryid)
   - [07. Locations & Chapters Directory (`/locations`)](#07-locations--chapters-directory-locations)
   - [08. Regional Branch Profile (`/locations/:id`)](#08-regional-branch-profile-locationsid)
   - [09. Contact Us & Support (`/contact`)](#09-contact-us--support-contact)
4. [Section B: Authentication & Member Portal](#4-section-b-authentication--member-portal)
   - [10. Member Login (`/login`)](#10-member-login-login)
   - [11. Member Sign Up (`/signup`)](#11-member-sign-up-signup)
   - [12. Forgot / Reset Password (`/forgot-password`)](#12-forgot--reset-password-forgot-password)
   - [13. User Profile & Digital ID Card (`/profile`)](#13-user-profile--digital-id-card-profile)
   - [14. Edit Member Profile (`/profile/edit`)](#14-edit-member-profile-profileedit)
   - [15. Membership Tier Selector (`/membership`)](#15-membership-tier-selector-membership)
   - [16. Individual Member Registration (`/membership/normal`)](#16-individual-member-registration-membershipnormal)
   - [17. Business Member Registration (`/membership/business`)](#17-business-member-registration-membershipbusiness)
   - [18. Unauthorized Access Screen (`/unauthorized`)](#18-unauthorized-access-screen-unauthorized)
5. [Section C: Location Admin System (Branch / Chapter Level)](#5-section-c-location-admin-system-branch--chapter-level)
   - [19. Location Admin Dashboard (`/admin`)](#19-location-admin-dashboard-admin)
   - [20. Member Directory & Approvals (`/admin/members`)](#20-member-directory--approvals-adminmembers)
   - [21. Branch Events Management (`/admin/events`)](#21-branch-events-management-adminevents)
   - [22. Branch Gallery & Media Vault (`/admin/gallery`)](#22-branch-gallery--media-vault-admingallery)
   - [23. Branch Profile & Settings (`/admin/settings`)](#23-branch-profile--settings-adminsettings)
6. [Section D: Central / Super Admin System (National Level)](#6-section-d-central--super-admin-system-national-level)
   - [24. Super Admin Strategic Dashboard (`/super-admin`)](#24-super-admin-strategic-dashboard-super-admin)
   - [25. Member Analytics & Demographics (`/super-admin/analytics`)](#25-member-analytics--demographics-super-adminanalytics)
   - [26. Nationwide Locations Management (`/super-admin/locations`)](#26-nationwide-locations-management-super-adminlocations)
   - [27. Centralized Events Overview (`/super-admin/events`)](#27-centralized-events-overview-super-adminevents)
   - [28. Centralized Media Gallery (`/super-admin/gallery`)](#28-centralized-media-gallery-super-admingallery)
   - [29. Advanced Analytics Engine (Coming Soon) (`/super-admin/coming-soon`)](#29-advanced-analytics-engine-coming-soon-super-admincoming-soon)
   - [30. System & RBAC Global Settings (`/super-admin/settings`)](#30-system--rbac-global-settings-super-adminsettings)
7. [Database Schema & Integration Mapping](#7-database-schema--integration-mapping)

---

## 1. Executive Summary & App Architecture

The **Nepal Agrawal Samaj** digital platform is a multi-tiered community management ecosystem built to unite Agrawal families, promote cultural heritage, empower business leaders, and streamline administrative workflows across **18+ regional chapter locations** in Nepal.

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           NEPAL AGRAWAL SAMAJ PLATFORM                          │
├──────────────────────────┬──────────────────────────┬───────────────────────────┤
│    PUBLIC VISITORS       │    REGISTERED MEMBERS    │   ADMINISTRATORS (2-TIER) │
│ • Homepage & Hero        │ • Digital ID & QR        │ • Location Admin (Branch) │
│ • Events & Gallery       │ • Registered Events      │ • Super Admin (National)  │
│ • Chapter Directory      │ • Family Profile         │ • Member Verification     │
│ • Online Registration    │ • Business Directory     │ • Analytics & Auditing    │
└──────────────────────────┴──────────────────────────┴───────────────────────────┘
```

### Core Architecture Highlights:
- **Navigation & Routing**: Declarative routing powered by `GoRouter` with deep linking, page transitions, and role-gated access guards.
- **State Management**: `flutter_riverpod` managing auth sessions, dynamic lists, profile states, and live filters.
- **Backend & Database**: **Supabase** acting as the backend engine (Postgres tables, Storage buckets for photos/documents, Row Level Security, Realtime log feeds).
- **Design System**: Rich aesthetics adhering to traditional Agrawal heritage (Crimson `#B5241C`, Deep Navy `#1B2A4A`, Warm Gold `#D4AF37`, Soft Cream `#FDFBF7`) with glassmorphism effects and responsive layouts for Mobile, Tablet, and Desktop.

---

## 2. Role-Based Access Control (RBAC) Matrix

| User Role | App Access Scope | Key Permissions & Capabilities | Default Landing Screen |
|---|---|---|---|
| **Public Visitor** | Public Pages Only | View home, read about us, browse events/gallery/locations, submit membership applications, send contact messages. | `/` (Home) |
| **Member (`member`)** | Public Pages + Profile Portal | All visitor rights + digital membership card with QR code, manage profile details, track event RSVPs, access member directory. | `/` (Home) / `/profile` |
| **Location Admin (`location_admin`)** | Chapter Admin Portal + Member Portal | Manage local chapter members, approve pending branch signups, create/edit local events, manage branch photo albums, edit branch contact details. | `/admin` |
| **Super Admin (`super_admin`)** | Full System Access (National Level) | Global strategic analytics, manage all 18+ locations, override member approvals, moderate national events/gallery, control RBAC, audit system logs. | `/super-admin` |

---

## 3. Section A: Public & Community Pages (Visitor View)

### 01. Home Screen (`/`)
- **File**: [`lib/features/home/presentation/home_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/home/presentation/home_screen.dart)
- **Route Constant**: `AppConstants.home`
- **Access Level**: Public
- **Key Features & Components**:
  - **Hero Section**: High-impact mountain and temple backdrop with dual-gradient overlay, custom NAS Crest Logo (laurel wreath, 8-point star, crimson shield, NAS ribbon banner), dynamic headline ("Nepal Agrawal Samaj"), tagline ("Unity • Culture • Service"), brief introduction, quick CTA buttons ("Become a Member", "Explore Events"), and top bar with Notifications bell modal sheet trigger and Profile shortcut.
  - **Live Community Stats Banner**: 4-metric floating card showing Active Members (5,200+), Regional Branches (18), Annual Events (130+), and Years of Service (38).
  - **Upcoming Events Carousel**: Interactive `PageView` carousel featuring highlighted events with event cover image, title, date, location, description snippet, and direct "Register Now" / "View Details" buttons.
  - **About Us Summary Section**: Highlight card summarizing mission, vision, cultural values, and community welfare initiatives.
  - **"What We Do" Grid**: 4 core pillar cards (Cultural Heritage Preservation, Youth & Education Empowerment, Business & Trade Networking, Social Welfare & Philanthropy) with custom icon avatars and descriptions.
  - **Join Community CTA Banner**: Eye-catching callout pushing registration for new members and business leaders.
  - **Our Locations Overview**: Interactive map placeholder (Nepal map visualization) and featured branch card with direct navigation link to `/locations`.
  - **Gallery Highlights Grid**: Staggered image grid showing recent community gatherings, cultural festivals (Dashain, Tihar, Agrasen Jayanti), and charitable drives.
  - **"Become a Member" Section**: Side-by-side comparison teaser for Individual vs. Business membership benefits.
  - **Bottom Navigation Bar**: Persistent `NASBottomNavBar` for seamless switching across Home, Events, Gallery, Locations, and Profile.

### 02. About Us Screen (`/about`)
- **File**: [`lib/features/about/presentation/about_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/about/presentation/about_screen.dart)
- **Route Constant**: `AppConstants.about`
- **Access Level**: Public
- **Key Features & Components**:
  - **Organizational History & Legacy**: Complete narrative of Nepal Agrawal Samaj, founding principles, Maharaja Agrasen heritage, and migration history in Nepal.
  - **Mission, Vision & Core Values**: Dedicated cards detailing Cultural Preservation, Unity, Business Synergy, and Social Philanthropy.
  - **Executive Leadership Board**: Grid of executive committee members with avatars, designations, contact links, and location affiliations.
  - **Key Milestones Timeline**: Visual vertical timeline highlighting organizational achievements from founding year to present day.
  - **Constitution & By-Laws Overview**: Informational download & view links for organizational charter documents.

### 03. Events Directory Screen (`/events`)
- **File**: [`lib/features/events/presentation/events_list_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/events/presentation/events_list_screen.dart)
- **Route Constant**: `AppConstants.events`
- **Access Level**: Public
- **Key Features & Components**:
  - **Segmented Filter Tabs**: Filter events by status: `All Events`, `Upcoming`, `Past Events`, and `My Registered Events`.
  - **Search & Category Filters**: Real-time search bar (by event title, city, or venue) and category pill chips (Cultural, Business Summit, Youth & Sports, Charity, Health Camp).
  - **Event Card Grid & List View**: Rich event cards displaying event cover photo, badge status, date badge (Month/Day), location, capacity indicator, and price (Free/Paid).
  - **Quick RSVP / Registration Trigger**: Direct tap action opening event detail or instant registration prompt.
  - **Empty & Loading States**: Clean skeletal loaders and empty state indicators when no matching events exist.

### 04. Event Detail & RSVP Screen (`/events/:id`)
- **File**: [`lib/features/events/presentation/event_detail_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/events/presentation/event_detail_screen.dart)
- **Route Constant**: `AppConstants.eventDetail`
- **Access Level**: Public (RSVP requires login)
- **Key Features & Components**:
  - **Hero Banner & Media Carousel**: High-resolution event cover image with overlay status badge and share/bookmark action buttons.
  - **Event Logistics & Details**: Date, start/end time, venue name, interactive map location link, organizing branch chapter, and contact coordinator.
  - **Comprehensive Event Description**: Full agenda, keynote speakers list, schedule breakdown, dress code, and entry instructions.
  - **Interactive Registration Modal / Bottom Sheet**: Single-click RSVP button, seat selection / guest count counter, special notes input, and payment summary (for ticketed events).
  - **Add to Calendar & Social Share**: Native calendar integration (.ics export / device calendar launcher) and quick social media sharing buttons.

### 05. Photo & Media Gallery (`/gallery`)
- **File**: [`lib/features/gallery/presentation/gallery_list_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/gallery/presentation/gallery_list_screen.dart)
- **Route Constant**: `AppConstants.gallery`
- **Access Level**: Public
- **Key Features & Components**:
  - **Album Grid Display**: Visual grid of photo and video albums categorized by event, year, or branch chapter.
  - **Branch & Category Filter Chips**: Filter media albums by location (Kathmandu, Pokhara, Biratnagar, etc.) or occasion (Holi, Diwali, AGM, Youth Meets).
  - **Album Cover Cards**: Shows album title, thumbnail collage preview, photo count badge, date created, and organizing chapter tag.
  - **Search Bar**: Quick search across album titles, keywords, and event tags.

### 06. Gallery Detail Lightbox (`/gallery/:id`)
- **File**: [`lib/features/gallery/presentation/gallery_detail_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/gallery/presentation/gallery_detail_screen.dart)
- **Route Constant**: `AppConstants.galleryDetail`
- **Access Level**: Public
- **Key Features & Components**:
  - **Full-Screen Lightbox Viewer**: Interactive image zoom, swipe navigation between photos, and high-res image renderer.
  - **Photo Metadata & Caption**: Display uploader details, caption, date taken, event tag, and view count.
  - **Download & Share Options**: One-tap image download to local gallery and direct sharing to WhatsApp/Facebook.
  - **Album Stats Header**: Total photos count, album creator/branch, and creation date.

### 07. Locations & Chapters Directory (`/locations`)
- **File**: [`lib/features/locations/presentation/locations_list_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/locations/presentation/locations_list_screen.dart)
- **Route Constant**: `AppConstants.locations`
- **Access Level**: Public
- **Key Features & Components**:
  - **Interactive Regional Map**: Map view displaying all 18+ Samaj branches across Provinces 1 to 7 of Nepal.
  - **Search & Province Filter**: Filter branches by region/province or search by city name (e.g. Kathmandu, Birgunj, Nepalgunj, Butwal).
  - **Branch Cards Grid**: Cards highlighting chapter name, executive leader, member count, office address, contact number, and email.
  - **Direct Action Links**: "View Branch Profile", "Call Office", and "Get Directions" via Google Maps.

### 08. Regional Branch Profile (`/locations/:id`)
- **File**: [`lib/features/locations/presentation/location_profile_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/locations/presentation/location_profile_screen.dart)
- **Route Constant**: `AppConstants.locationProfile`
- **Access Level**: Public
- **Key Features & Components**:
  - **Branch Header Banner**: High-res cover photo of the local chapter building or committee, branch logo, and location title.
  - **Chapter Executive Committee Grid**: Photos and roles of Branch President, Vice President, Secretary, Treasurer, and Committee Members.
  - **Local Chapter Statistics**: Total active members, local events hosted, active youth wing members, and local welfare projects.
  - **Branch Contact & Directions**: Full postal address, phone, email, operating hours, and embedded map view.
  - **Branch Feed**: Local chapter events list and branch media gallery preview.

### 09. Contact Us & Support (`/contact`)
- **File**: [`lib/features/contact/presentation/contact_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/contact/presentation/contact_screen.dart)
- **Route Constant**: `AppConstants.contact`
- **Access Level**: Public
- **Key Features & Components**:
  - **Inquiry Form**: Form fields for Full Name, Email, Phone Number, Subject Category (General Inquiry, Membership Assistance, Event Sponsorship, Feedback), and Message.
  - **Central Office Contact Details**: HQ address (Kathmandu, Nepal), official phone numbers, email addresses, and working hours.
  - **Interactive Google Map Location**: Embedded location map of Central Headquarters.
  - **Social Media Links**: Official links to Facebook, Instagram, LinkedIn, and YouTube channels.

---

## 4. Section B: Authentication & Member Portal

### 10. Member Login (`/login`)
- **File**: [`lib/features/auth/presentation/login_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/auth/presentation/login_screen.dart)
- **Route Constant**: `AppConstants.login`
- **Access Level**: Public (Redirects logged-in users to `/profile`)
- **Key Features & Components**:
  - **Authentication Form**: Email / Phone Number input field with validation, secure Password field with visibility toggle.
  - **Remember Me & Forgot Password**: Quick checkbox and link to password recovery flow.
  - **Role-Based Redirect Logic**: Automatic redirection post-auth (Members → `/profile` or `/`, Location Admin → `/admin`, Super Admin → `/super-admin`).
  - **Sign Up Callout**: Quick transition link to `/membership` for new users.

### 11. Member Sign Up (`/signup`)
- **File**: [`lib/features/auth/presentation/signup_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/auth/presentation/signup_screen.dart)
- **Route Constant**: `AppConstants.signup`
- **Access Level**: Public
- **Key Features & Components**:
  - **Account Creation Form**: Full Name, Phone Number, Email, Password, Confirm Password, and Home Branch selection dropdown.
  - **Terms & Privacy Consent**: Checkbox agreeing to Nepal Agrawal Samaj constitution and privacy policies.
  - **Redirect to Registration Tier**: Prompt to complete individual or business membership form.

### 12. Forgot / Reset Password (`/forgot-password`)
- **File**: [`lib/features/auth/presentation/forgot_password_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/auth/presentation/forgot_password_screen.dart)
- **Route Constant**: `AppConstants.forgotPassword`
- **Access Level**: Public
- **Key Features & Components**:
  - **Reset Request Form**: Registered Email / Phone input field with automated OTP or password reset link trigger via Supabase Auth.
  - **Success Confirmation View**: Instructions on checking inbox/SMS with resend timer.

### 13. User Profile & Digital ID Card (`/profile`)
- **File**: [`lib/features/auth/presentation/profile_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/auth/presentation/profile_screen.dart)
- **Route Constant**: `AppConstants.profile`
- **Access Level**: Registered Members & Admins
- **Key Features & Components**:
  - **Digital Membership Card**: Premium card displaying Member Name, Unique Member ID (e.g. `NAS-KTM-2026-0842`), Photo, Membership Tier (General / Life / Business Member), Branch Name, Status Badge (Active/Pending), and QR Code for instant event check-ins.
  - **Personal Information Summary**: Contact Info, Gotra, Family Details, Address, and Occupation/Business Name.
  - **My Event Registrations**: List of upcoming and past events registered by the member with digital entry tickets.
  - **Role Badge & Quick Admin Portal Switch**: If user is `location_admin` or `super_admin`, displays a prominent banner button to open Admin Dashboard.
  - **Account Actions**: Edit Profile button, Change Password, and Logout button.

### 14. Edit Member Profile (`/profile/edit`)
- **File**: [`lib/features/auth/presentation/profile_edit_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/auth/presentation/profile_edit_screen.dart)
- **Route Constant**: `${AppConstants.profile}/edit`
- **Access Level**: Registered Members
- **Key Features & Components**:
  - **Avatar & Cover Upload**: Avatar image picker with crop/upload functionality to Supabase Storage.
  - **Editable Fields Form**: Contact details, Gotra, Emergency Contact, Permanent & Current Address, Occupation, and Bio.
  - **Save & Cancel Actions**: Form state management with error indicators and success feedback toasts.

### 15. Membership Tier Selector (`/membership`)
- **File**: [`lib/features/membership/presentation/membership_selector_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/membership/presentation/membership_selector_screen.dart)
- **Route Constant**: `AppConstants.membershipSelector`
- **Access Level**: Public / Logged-in Users
- **Key Features & Components**:
  - **Dual Tier Selection Grid**: Side-by-side comparative cards for:
    1. **General / Life Individual Membership**: Personal community involvement, event discounts, voting rights, family directory inclusion.
    2. **Business / Entrepreneur Membership**: Corporate directory listing, business networking summits, promotional banners, B2B collaboration access.
  - **Feature Checklist**: Clear checkmark list comparing benefits, annual/lifetime dues, and required documents.
  - **Direct Registration Button**: Route triggers to `/membership/normal` or `/membership/business`.

### 16. Individual Member Registration (`/membership/normal`)
- **File**: [`lib/features/membership/normal_registration/presentation/normal_registration_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/membership/normal_registration/presentation/normal_registration_screen.dart)
- **Route Constant**: `AppConstants.normalRegistration`
- **Access Level**: Public / Logged-in Users
- **Key Features & Components**:
  - **Multi-Step Application Form**:
    - **Step 1**: Personal Information (Full Name, DOB, Gender, Blood Group, Gotra).
    - **Step 2**: Contact & Address (Mobile, Email, Permanent & Temporary Address, Citizenship No.).
    - **Step 3**: Branch & Family Details (Select Home Branch, Father/Spouse Name, Family Member Count).
    - **Step 4**: Photo & Document Upload (PP Photo, Citizenship/Passport scan).
  - **Payment Gateways Integration**: Payment summary and integration placeholder for membership fee payment (eSewa, Khalti, Bank Transfer).
  - **Application Submit & Tracking ID**: Confirmation screen generating reference tracking ID for admin approval status.

### 17. Business Member Registration (`/membership/business`)
- **File**: [`lib/features/membership/business_registration/presentation/business_registration_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/membership/business_registration/presentation/business_registration_screen.dart)
- **Route Constant**: `AppConstants.businessRegistration`
- **Access Level**: Public / Logged-in Users
- **Key Features & Components**:
  - **Enterprise Application Form**:
    - **Step 1**: Business Details (Company Name, Registration No., Industry Sector, Establishment Year).
    - **Step 2**: Contact & Location (Company Address, Office Phone, Website, Branch Chapter).
    - **Step 3**: Business Profile & Services (Short Bio, Products/Services Offered, Employee Count).
    - **Step 4**: Corporate Documents Upload (PAN/VAT Certificate, Company Registration Certificate, Brand Logo).
  - **Directory Listing Opt-in**: Options for inclusion in the Agrawal Business Directory.
  - **Submission Confirmation**: Pending verification workflow with location admin notification trigger.

### 18. Unauthorized Access Screen (`/unauthorized`)
- **File**: Embedded in [`lib/app/router.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/app/router.dart)
- **Route Constant**: `AppConstants.unauthorized`
- **Access Level**: Gated Route Guard Fallback
- **Key Features & Components**:
  - **Permission Lock State**: Icon, error message ("You do not have permission to access this page"), and "Go Home" navigation button.

---

## 5. Section C: Location Admin System (Branch / Chapter Level)

> **Doc Specs Directory**: [`docs/admin_pages/`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages)

### 19. Location Admin Dashboard (`/admin`)
- **File**: [`lib/features/location_admin/dashboard/presentation/admin_dashboard_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/location_admin/dashboard/presentation/admin_dashboard_screen.dart)
- **Spec Doc**: [`01_location_admin_dashboard.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/01_location_admin_dashboard.md)
- **Route Constant**: `AppConstants.adminDashboard`
- **Access Level**: Role `location_admin` or `super_admin`
- **Key Features & Components**:
  - **Branch Metrics Header**: Cards showing Total Branch Members, Pending Member Applications badge, Upcoming Local Events count, and Gallery Media Storage usage.
  - **Quick Action Hub**: Floating/Grid action buttons to Add New Member, Create Event, Upload Photo Album, and Edit Branch Profile.
  - **Pending Verification Banner**: High-priority alert banner listing pending registrations requiring branch admin review.
  - **Recent Activity Stream**: Real-time audit log of member signups, event registrations, and media updates within the chapter.

### 20. Member Directory & Approvals (`/admin/members`)
- **File**: [`lib/features/location_admin/members/presentation/members_management_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/location_admin/members/presentation/members_management_screen.dart)
- **Spec Doc**: [`02_location_admin_members_management.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/02_location_admin_members_management.md)
- **Route Constant**: `AppConstants.adminMembers`
- **Access Level**: Role `location_admin` or `super_admin`
- **Key Features & Components**:
  - **Member Data Table & List**: Searchable, filterable list of all members registered under the specific branch chapter.
  - **Status Filter Tabs**: `All Members`, `Active`, `Pending Review`, `Inactive/Suspended`.
  - **Member Review Drawer / Modal**: Detailed view of pending applicant information, submitted documents (Citizenship/Photo), and one-tap Approve / Reject actions with remarks.
  - **Member Status Toggle & Edit**: Change membership status, assign local committee roles, or export member roster to CSV/PDF.

### 21. Branch Events Management (`/admin/events`)
- **File**: [`lib/features/location_admin/events_management/presentation/events_management_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/location_admin/events_management/presentation/events_management_screen.dart)
- **Spec Doc**: [`03_location_admin_events_management.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/03_location_admin_events_management.md)
- **Route Constant**: `AppConstants.adminEvents`
- **Access Level**: Role `location_admin` or `super_admin`
- **Key Features & Components**:
  - **Event Creation Wizard**: Floating Action Button (FAB) or button launching event creation modal (Title, Category, Cover Image Upload, Date/Time, Venue, Max Seats, Ticket Dues).
  - **Branch Events List**: Filter by `Upcoming`, `Ongoing`, `Past`, and `Draft`.
  - **Attendee Roster Management**: View registered attendees for any event, check-in attendees via QR scan, export attendee list.
  - **Edit / Cancel Event**: Modify event details, send notification alerts to registered members, or cancel event.

### 22. Branch Gallery & Media Vault (`/admin/gallery`)
- **File**: [`lib/features/location_admin/gallery_management/presentation/gallery_management_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/location_admin/gallery_management/presentation/gallery_management_screen.dart)
- **Spec Doc**: [`04_location_admin_gallery_management.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/04_location_admin_gallery_management.md)
- **Route Constant**: `AppConstants.adminGallery`
- **Access Level**: Role `location_admin` or `super_admin`
- **Key Features & Components**:
  - **Album Creation & Bulk Photo Uploader**: Upload multiple high-res photos to Supabase Storage with album title, date, and description.
  - **Storage Usage Bar**: Monitor media storage space utilized by the chapter.
  - **Album Management Grid**: Edit album details, rearrange photo order, set cover image, or delete outdated media.

### 23. Branch Profile & Settings (`/admin/settings`)
- **File**: [`lib/features/location_admin/branch_settings/presentation/branch_settings_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/location_admin/branch_settings/presentation/branch_settings_screen.dart)
- **Spec Doc**: [`05_location_admin_branch_settings.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/05_location_admin_branch_settings.md)
- **Route Constant**: `AppConstants.adminSettings`
- **Access Level**: Role `location_admin` or `super_admin`
- **Key Features & Components**:
  - **Branch Information Form**: Edit official chapter name, office address, contact phone, email, social links, and Google Map coordinates.
  - **Branch Mission & Leader Profile**: Update Branch President bio, photo, and office working hours.
  - **Save Configuration**: Sync changes across the public `/locations/:id` profile screen instantly.

---

## 6. Section D: Central / Super Admin System (National Level)

### 24. Super Admin Strategic Dashboard (`/super-admin`)
- **File**: [`lib/features/super_admin/dashboard/presentation/super_admin_dashboard_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/super_admin/dashboard/presentation/super_admin_dashboard_screen.dart)
- **Spec Doc**: [`06_super_admin_dashboard.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/06_super_admin_dashboard.md)
- **Route Constant**: `AppConstants.superAdminDashboard`
- **Access Level**: Role `super_admin`
- **Key Features & Components**:
  - **Nationwide KPI Metrics Banner**: Real-time counters showing Total National Members (5,200+), Active Chapters (18), Total National Events (130+), and Total Business Directory Members.
  - **National Module Cards Grid**: Navigation cards to Member Analytics, Locations Management, Centralized Events, Centralized Gallery, System Settings, and Audit Log.
  - **Chapter Activity Heatmap / Leaderboard**: Highlighting top performing branch chapters by member growth and event engagement.

### 25. Member Analytics & Demographics (`/super-admin/analytics`)
- **File**: [`lib/features/super_admin/analytics/presentation/member_analytics_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/super_admin/analytics/presentation/member_analytics_screen.dart)
- **Spec Doc**: [`07_super_admin_member_analytics.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/07_super_admin_member_analytics.md)
- **Route Constant**: `AppConstants.superAdminAnalytics`
- **Access Level**: Role `super_admin`
- **Key Features & Components**:
  - **Interactive Data Charts (`fl_chart`)**: Growth curves for member signups, demographic pie charts (Gotra breakdown, Age groups), and Province distribution bar charts.
  - **Date Range Picker**: Filter metrics by Month, Quarter, Year, or Custom Range.
  - **National Growth Insights**: Conversion rate metrics (Pending to Approved members), Business vs Individual member ratios.

### 26. Nationwide Locations Management (`/super-admin/locations`)
- **File**: [`lib/features/super_admin/locations_management/presentation/locations_management_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/super_admin/locations_management/presentation/locations_management_screen.dart)
- **Spec Doc**: [`08_super_admin_locations_management.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/08_super_admin_locations_management.md)
- **Route Constant**: `AppConstants.superAdminLocations`
- **Access Level**: Role `super_admin`
- **Key Features & Components**:
  - **Branch Master Directory**: Complete list of all 18+ regional chapters across Nepal with status indicators (Active/Inactive).
  - **Add New Branch Chapter Wizard**: Creation form to register new regional chapters, assign initial Location Admin credentials, and define geographical jurisdiction.
  - **Branch Admin Assignment Drawer**: Change assigned Branch Admins, revoke access, or update chapter hierarchy.

### 27. Centralized Events Overview (`/super-admin/events`)
- **File**: [`lib/features/super_admin/centralized_events_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/super_admin/centralized_events_screen.dart)
- **Spec Doc**: [`09_super_admin_centralized_events.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/09_super_admin_centralized_events.md)
- **Route Constant**: `AppConstants.superAdminEvents`
- **Access Level**: Role `super_admin`
- **Key Features & Components**:
  - **Nationwide Events Calendar & Table**: Comprehensive view of all events created by all 18 branch chapters across Nepal.
  - **National Event Approval & Feature Toggle**: Super admin toggle to feature local branch events on the main Home screen hero carousel.
  - **Attendance & Revenue Analytics**: Consolidated registration statistics and ticketing revenue reporting.

### 28. Centralized Media Gallery (`/super-admin/gallery`)
- **File**: [`lib/features/super_admin/centralized_gallery_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/super_admin/centralized_gallery_screen.dart)
- **Spec Doc**: [`10_super_admin_centralized_gallery.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/10_super_admin_centralized_gallery.md)
- **Route Constant**: `AppConstants.superAdminGallery`
- **Access Level**: Role `super_admin`
- **Key Features & Components**:
  - **National Media Vault**: Repository containing 12,000+ historical and cultural photos from across all chapters.
  - **Cross-Branch Media Moderation**: Review, approve, or feature photo albums on the national public gallery.
  - **Storage & Backup Diagnostics**: Supabase Storage bucket utilization stats and backup controls.

### 29. Advanced Analytics Engine (Coming Soon) (`/super-admin/coming-soon`)
- **File**: [`lib/features/super_admin/analytics/presentation/analytics_coming_soon_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/super_admin/analytics/presentation/analytics_coming_soon_screen.dart)
- **Spec Doc**: [`11_super_admin_analytics_coming_soon.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/11_super_admin_analytics_coming_soon.md)
- **Route Constant**: `AppConstants.superAdminComingSoon`
- **Access Level**: Role `super_admin`
- **Key Features & Components**:
  - **AI & Predictive Community Intelligence Teaser**: Preview screen outlining upcoming features (AI-driven member matching, business synergy recommendations, demographic expansion forecasting).
  - **Feature Roadmap & Feedback Form**: Roadmap timeline and internal feedback submission input.

### 30. System & RBAC Global Settings (`/super-admin/settings`)
- **File**: [`lib/features/super_admin/settings/presentation/settings_screen.dart`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/lib/features/super_admin/settings/presentation/settings_screen.dart)
- **Spec Doc**: [`12_super_admin_settings.md`](file:///Users/cupno_oodles/Desktop/agrawal-samaj/docs/admin_pages/12_super_admin_settings.md)
- **Route Constant**: `AppConstants.superAdminSettings`
- **Access Level**: Role `super_admin`
- **Key Features & Components**:
  - **Role-Based Access Control (RBAC)**: Manage user roles (`member`, `location_admin`, `super_admin`), permissions matrix, and admin access keys.
  - **System Maintenance & Feature Flags**: Global toggles for maintenance mode, registration open/closed status, payment gateway settings, and notification service config.
  - **Security Audit Log**: Complete immutable log tracking admin logins, role changes, member approvals, and system modifications.

---

## 7. Database Schema & Integration Mapping

The application connects to **Supabase Postgres** through the following table mappings configured in `AppConstants`:

```
               ┌───────────────────────────────┐
               │          PROFILES             │
               │ (id, role, location_id, etc.) │
               └───────────────┬───────────────┘
                               │
       ┌───────────────────────┼───────────────────────┐
       ▼                       ▼                       ▼
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│  LOCATIONS   │       │    EVENTS    │       │  GALLERIES   │
└──────────────┘       └───────┬──────┘       └───────┬──────┘
                               │                      │
                               ▼                      ▼
                       ┌──────────────┐       ┌──────────────┐
                       │  EVENT_REG   │       │ GALLERY_PICS │
                       └──────────────┘       └──────────────┘
```

| Table Name Constant | Database Table | Key Attributes & Description |
|---|---|---|
| `AppConstants.locationsTable` | `locations` | ID, name, region/province, address, phone, email, leader_name, leader_photo, coordinates, member_count. |
| `AppConstants.profilesTable` | `profiles` | User ID, full_name, email, phone, gotra, address, membership_tier, status (`pending`/`active`), location_id, role (`member`/`location_admin`/`super_admin`), qr_code. |
| `AppConstants.businessProfilesTable` | `business_profiles` | Profile ID, company_name, reg_number, industry, website, pan_vat, logo_url, description. |
| `AppConstants.eventsTable` | `events` | ID, location_id, title, description, start_time, end_time, venue, cover_image, status, is_featured. |
| `AppConstants.eventRegistrationsTable` | `event_registrations` | Registration ID, event_id, user_id, status, ticket_code, guest_count. |
| `AppConstants.galleriesTable` | `galleries` | Album ID, location_id, title, cover_photo_url, created_at. |
| `AppConstants.galleryPhotosTable` | `gallery_photos` | Photo ID, gallery_id, photo_url, caption, upload_date. |
| `AppConstants.contactMessagesTable` | `contact_messages` | Message ID, sender_name, email, phone, subject, message, status. |
| `AppConstants.paymentsTable` | `payments` | Transaction ID, user_id, amount, payment_gateway, status, timestamp. |
| `AppConstants.activityLogTable` | `activity_log` | Log ID, user_id, action, target_type, timestamp, ip_address. |

---

*Document compiled for Nepal Agrawal Samaj App.*
