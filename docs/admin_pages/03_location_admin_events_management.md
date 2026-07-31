# Events Management Page (`/admin/events`)

## 1. Page Overview & Purpose
- **Page Title**: Events Management (Location Admin)
- **Role Target**: Branch / Location Administrator
- **Purpose**: Manage chapter cultural and business events, track registrations/RSVPs, view financial revenue, switch event categories (Upcoming, Past, Cancelled), edit details, inspect attendee rosters, and create new events.

## 2. Technical File Mapping
- **File Location**: [events_management_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/location_admin/events_management/presentation/events_management_screen.dart)
- **Route Path**: `AppConstants.adminEvents` (`/admin/events`)
- **Widget Type**: `StatefulWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Events Management')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Header Section:
│       │   ├── Title: "Events Management" (NASTypography.headlineMd)
│       │   └── Subtext: "Oversee and organize community gatherings for your chapter."
│       ├── Segmented Filter Control:
│       │   └── Pill Container (Upcoming / Past / Cancelled)
│       ├── Featured Event Card:
│       │   └── NASCard:
│       │       ├── Badges: Cultural + Active
│       │       ├── Event Title: "Annual Heritage Gala 2024"
│       │       ├── Info Row: Registered count (1,240) + Date (Oct 15, 2024)
│       │       └── Action Row: "Edit Details" (Secondary) + "View Roster" (Primary)
│       ├── Quick Summary Card (Dark Container):
│       │   ├── Title: "Quick Summary" (Current month's performance)
│       │   ├── Metric 1: Total Events (12)
│       │   ├── Metric 2: New RSVPs (+458)
│       │   ├── Metric 3: Revenue (NPR 45,000)
│       │   └── Full-width Button: "Download Report"
│       └── Additional Events List:
│           └── ListView.separated -> NASCard
│               ├── Event 1: Entrepreneurship Summit (BUSINESS, Samaj Hall, 84 Booked)
│               ├── Event 2: Youth Cultural Fest (YOUTH, National Stadium, 312 Booked)
│               └── Event 3: Senior Wellness Day (HEALTH, Central Clinic Wing, 45 Booked)
├── FloatingActionButton: "+" (Create Event Dialog trigger)
└── BottomNavigationBar: NASBottomNav (Index 2: Events active tab)
```

## 4. Components & Tokens Used
- `NASAppBar`
- `NASCard`
- `NASBadge` (cultural, active, business variants)
- `NASPrimaryButton`, `NASSecondaryButton`
- `FloatingActionButton`
- `NASBottomNav`

## 5. Interactive Actions & Triggers
- Segmented toggle state (`_selectedFilter`: 0=Upcoming, 1=Past, 2=Cancelled)
- "View Roster" -> Toast notification / roster view trigger
- "Download Report" -> Export report toast notification
- Floating Action Button `+` -> Opens new event creation form

## 6. Redesign & UI Upgrade Roadmap
- **Interactive Calendar View**: Add toggle between List View and Monthly Calendar View with event pin indicators.
- **Event Creation Wizard**: Add step-by-step event wizard modal (Basic Info -> Date/Time/Venue -> Ticket/Pricing -> Banner Upload -> Publishing).
- **Attendee Roster Management**: Add full interactive drawer/dialog with search, check-in QR scanner toggle, and CSV export.
- **Revenue Analytics Widget**: Integrate chart breakdown of ticket sales vs sponsorship revenue.
