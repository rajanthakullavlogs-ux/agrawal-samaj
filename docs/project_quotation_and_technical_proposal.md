# Nepal Agrawal Samaj — Comprehensive Application Proposal & Technical Quotation

**Document Title**: System Proposal & Technical Specification for Quotation  
**Project Name**: Nepal Agrawal Samaj Mobile & Web Application Platform  
**Target Organization**: Nepal Agrawal Samaj (Central Committee & Regional Chapters)  
**Date**: August 2026  
**Document Version**: 2.0 (Production-Ready Release)  

---

## 1. Executive Summary & System Overview

The **Nepal Agrawal Samaj Mobile & Web Platform** is an enterprise-grade, cross-platform digital solution designed to unify, empower, and streamline operations for the Agrawal community across Nepal. The platform bridges public community engagement with multi-tier administrative governance, connecting individual members, 18+ regional branch chapters, and the Central Executive Committee.

### Key Objectives
1. **Community Integration**: Connect community members nationwide through cultural updates, business networking, educational initiatives, and social welfare programs.
2. **Multi-Tier Governance**: Provide dedicated administrative dashboards for **Location Admins** (Regional Branch Leaders) and **Super Admins** (Central Executive Committee).
3. **Real-Time Data Synchronization**: Ensure instant state updates across membership registrations, nationwide event RSVPs, photo galleries, and chapter branch settings.
4. **Premium Design Aesthetics**: Deliver a state-of-the-art visual experience utilizing curated maroon and gold heritage themes, glassmorphism, responsive width layouts, and smooth 60fps micro-animations.

---

## 2. Platform Architecture & Technology Stack

The platform is engineered using modern, scalable, industry-standard technologies ensuring high performance, robust security, and seamless cross-platform deployment.

| Technology Domain | Library / Tool | Description & Technical Role |
| :--- | :--- | :--- |
| **Frontend Framework** | **Flutter 3.x / Dart** | Cross-platform framework supporting single-codebase deployment for Android (APK/AAB), iOS, and Web. |
| **State Management** | **Flutter Riverpod (v2.6.1)** | Reactive, type-safe state management utilizing `StateNotifierProvider` for live sync between UI and repository layers. |
| **Navigation & Routing** | **GoRouter (v14.8.1)** | Declarative routing with role-based access guards (`redirect`), deep linking, and custom slide transition page builders. |
| **Backend & Database** | **Supabase (PostgreSQL)** | Cloud-native database providing Row-Level Security (RLS), real-time subscriptions, SQL migrations, and secure file storage. |
| **Data Analytics & Charts**| **fl_chart (v0.70.2)** | High-performance charting engine rendering demographic trends and member growth velocity bar charts. |
| **Typography & Styling** | **Google Fonts (Outfit / Inter)** | Custom typography paired with curated color tokens (`AppColors.primary`, `AppColors.accent`, maroon & gold gradients). |

---

## 3. Complete Module-by-Module Feature Breakdown

### Module A: Public Member Portal (Android / iOS / Web)

#### 1. Home Dashboard (`/`)
- **Hero Banner**: High-impact introductory section featuring community taglines (*Unity • Culture • Service*), quick membership registration CTA, event discovery button, interactive notification bell, and user profile avatar.
- **Featured Upcoming Events Carousel**: Touch-enabled carousel showcasing high-priority upcoming national and regional gatherings with date badges and venue details.
- **About Nepal Agrawal Samaj**: Brief history card with image highlights leading directly to the detailed About Us page.
- **What We Do Grid**: 6-card interactive grid highlighting core pillars: *Culture, Business, Education, Youth, Social Work, and Women Empowerment*.
- **Nepal Regional Chapters Teaser**: Interactive map placeholder highlighting active regional branches (Kathmandu, Pokhara, Biratnagar, Birgunj, Butwal, etc.).
- **Gallery Highlights & Join Community Banners**: Photo showcase grid and membership conversion CTAs.

#### 2. About Us (`/about`)
- Comprehensive background on the founding of Nepal Agrawal Samaj (1988 to present).
- Executive leadership directory, organizational mission statement, and constitution downloads.

#### 3. Events Portal (`/events` & `/events/:id`)
- **Multi-Dimensional Live Filtering**: Filter events by **Status** (*Upcoming, Past, All*), **Province** (*Bagmati, Koshi, Gandaki, Madhesh, Lumbini*), and **Category** (*Business, Cultural, Youth, Health, Social*).
- **Interactive Event Cards**: Displays event poster, date badge, time, venue, organizing chapter, and description.
- **RSVP Registration Modal**: Enables members to instantly submit attendance registrations with name and mobile number confirmation.
- **Event Detail Page**: Dedicated view containing event banner poster, venue map coordinates, calendar exports, and organizer contacts.
- **"Have an Event to Share?" Banner**: Allows members to submit local events to branch administrators.

#### 4. Media Vault & Photo Gallery (`/gallery` & `/gallery/:id`)
- **Live Category Filter Chips**: Filter photo highlights and albums by category (*Business, Cultural, Social Work*).
- **Full-Screen Zoomable Lightbox**: Tapping any thumbnail launches an `InteractiveViewer` supporting **pinch-to-zoom** (up to 4x magnification), panning, and double-tap zoom.
- **Linked Event Reference Card**: Each photo preview displays its associated event title, date, venue, and a **"View Event Details"** button navigating directly to the event page.
- **Recent Albums Carousel**: Organized album collections leading to deep album photo grids.

#### 5. Regional Chapters & Locations Directory (`/locations` & `/locations/:id`)
- **Live Search**: Search input allowing users to find branches by city or branch name.
- **Interactive Nepal Map Pins**: Visual representation of branch density across all 77 districts and 7 provinces.
- **Branch Profile Pages**: Dedicated profiles displaying office addresses, lead executive contact details, member counts, and localized announcements.

#### 6. Membership Hub & Registration (`/membership`)
- **Tier Selection**: Interactive selector for **Individual Membership** and **Business / Enterprise Registration**.
- **Individual Registration Form (`/membership/normal`)**: Includes inputs for Full Name, Email, Phone, Permanent Address, Gender, Required **Regional Chapter Selection**, and Bylaw Declaration.
- **Business Registration Form (`/membership/business`)**: Includes Company Name, Registration Number, Industry Category, Business Address, and Executive Representative info.

#### 7. Profile & Notification System
- **User Profile (`/profile`)**: Manage personal details, membership ID card, and application status (*Pending, Active*).
- **Notifications Bottom Sheet**: Interactive modal displaying real-time alerts for membership approvals, event reminders, and new gallery uploads.

---

### Module B: Location Admin Management Portal (`/admin/*`)

Designed for Regional Branch Leaders to govern localized branch operations.

1. **Location Admin Dashboard (`/admin/dashboard`)**:
   - **Executive Top Bar**: Branch switcher dropdown (*Kathmandu, Birgunj, Biratnagar, Pokhara, Butwal*), notification bell, profile avatar, and "Exit to Home" navigation control.
   - **Metrics Overview Grid**: Real-time counter cards with sparkline trend indicators for *Total Members, Active Members, Upcoming Events, and Past Events* powered by Riverpod state providers.
   - **Quick Actions Strip**: Instant buttons for *Approve Members, Create Event, Manage Gallery, and Branch Settings*.
   - **Filterable Activity Feed**: Filter chapter logs by *Registrations, Events, Donations, and Announcements*.
   - **Pending Approvals Banner**: High-priority alert drawer for unapproved member applications.

2. **Members Management (`/admin/members`)**:
   - Filter members by status (*Active, Pending Review, Inactive, Lifetime, Trustee*).
   - **Add Member Dialog**: Form to manually add new members to the branch database.
   - **Member Action Drawer**: Inspect member details, approve pending applications to `ACTIVE`, or reject/deactivate records with instant state sync.

3. **Events Management (`/admin/events`)**:
   - **Create Event Wizard**: Modal form to publish new chapter events directly to the public event feed.
   - **QR Ticket Scanner**: Modal tool for scanning attendee event passes during check-in.
   - **Broadcast Announcement**: Push notice dialog to send SMS/App notifications to registered attendees.

4. **Gallery & Media Management (`/admin/gallery`)**:
   - Upload new event photo albums, assign category tags, and monitor branch media storage limits.

5. **Branch Settings (`/admin/settings`)**:
   - Configure branch name, mission statement, office address, leader bio, phone, and contact email with automatic Supabase persistence.

---

### Module C: Super Admin Central Executive Portal (`/super-admin/*`)

Designed for the Central Committee Executive Board for nationwide oversight.

1. **Super Admin Dashboard (`/super-admin`)**:
   - Executive metrics tracking nationwide total members, registered businesses, active chapters, and annual revenue.
   - Access to executive modules: *Member Analytics, Locations Management, Centralized Events, and System Settings*.

2. **Member Analytics (`/super-admin/analytics`)**:
   - Demographic distribution insights across Nepal's 7 provinces.
   - Interactive bar charts (`fl_chart`) tracking month-over-month membership growth velocity.

3. **Locations & Chapters Management (`/super-admin/locations`)**:
   - Central directory to add new regional chapters, assign chapter leaders, and audit branch performance.

4. **Role-Based Access Control & System Security (`/super-admin/settings`)**:
   - **RBAC Role & Key Management**: Modal tool to view, assign, and regenerate security keys for Super Admins, Location Admins, and Moderators.
   - **Global System Controls**: Toggles for maintenance mode, public signup registration locks, and automated email notice dispatchers.

---

## 4. Security, Performance & Data Synchronization Architecture

1. **Riverpod Reactive State Architecture**:
   - All admin actions (approving members, publishing events, updating branch profiles) instantly mutate Riverpod `StateNotifiers`, ensuring zero-latency updates across both public and admin views.
2. **Supabase Database & Row-Level Security (RLS)**:
   - Built on PostgreSQL with seed scripts (`001_initial_schema.sql` & `002_seed_data.sql`).
   - RLS policies ensure Location Admins can only mutate data belonging to their assigned branch location, while Super Admins maintain global write access.
3. **Custom Page Transition Routing**:
   - Forward push navigation utilizes right-to-left slide animations (`_slideTransitionPage`), while back button actions pop naturally left-to-right. Bottom bar tab transitions switch instantly with `NoTransitionPage`.

---

## 5. Scope Deliverables & Financial Quotation

### Deliverable Checklist

- [x] **Cross-Platform Mobile App (Android APK/AAB & iOS Build)**
- [x] **Web Application Portal**
- [x] **Public Member Services Module** (Home, About, Events, Gallery, Locations, Registration)
- [x] **Location Admin Management System** (5 Core Admin Screens)
- [x] **Super Admin Central Executive Control Panel** (5 Core Executive Screens)
- [x] **Supabase Production Database Schemas & Seed Data Scripts**
- [x] **Full-Stack Riverpod State Synchronization**
- [x] **Clean Source Code & GitHub Repository Access**

---

### Project Investment & Quotation Breakdown

| Phase / Component | Deliverable Description | Estimated Effort | Investment (NPR) |
| :--- | :--- | :--- | :--- |
| **Phase 1: Architecture & UI/UX Design** | Custom Design Tokens, Maroon/Gold Theme, Typography, Wireframing, Layouts | 2 Weeks | **NPR 75,000** |
| **Phase 2: Public Member App Development** | Home, Events (w/ Filters & RSVP), Gallery (w/ Lightbox Zoom), Locations, Registrations | 3 Weeks | **NPR 150,000** |
| **Phase 3: Location Admin Management System** | Dashboard, Member Approvals, Event Creator, QR Scanner, Branch Settings | 2.5 Weeks | **NPR 120,000** |
| **Phase 4: Super Admin Control & Analytics** | Central Dashboard, Member Analytics Charts (`fl_chart`), Chapter Control, RBAC Security | 2 Weeks | **NPR 110,000** |
| **Phase 5: Backend, Supabase Database & Security** | PostgreSQL Schema Setup, Seed Scripts, Row Level Security (RLS), Realtime Sync | 1.5 Weeks | **NPR 65,000** |
| **Phase 6: QA, Device Testing & Deployment** | Device Verification (Android 16 / Galaxy S23), Performance Optimization, APK Build | 1 Week | **NPR 40,000** |
| **Maintenance & Support (1st Year)** | Bug Fixes, OS Compatibility Updates, Server Health Monitoring (12 Months) | Ongoing | **INCLUDED (Free)** |
| **TOTAL PROJECT INVESTMENT** | **Complete Full-Stack Platform Deployment (Mobile + Web + Admin)** | **12 Weeks Total** | **NPR 560,000** |

---

### Payment Terms & Milestone Schedule
1. **Initial Advance / Project Kickoff**: 30% upon signing contract
2. **Mid-Project Milestone (Public App & Database Completion)**: 40% upon demo review
3. **Final Delivery & Handover (Admin Systems & Production Release)**: 30% upon APK/Web launch

---

*Prepared by*:  
**Engineering & Product Development Team**  
*Repository*: [github.com/rajanthakullavlogs-ux/agrawal-samaj](https://github.com/rajanthakullavlogs-ux/agrawal-samaj)  
*Status*: Production Ready & Device Verified  
