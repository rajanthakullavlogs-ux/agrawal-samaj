# Location Admin Dashboard (`/admin/dashboard`)

## 1. Page Overview & Purpose
- **Page Title**: Location Admin Dashboard (Kathmandu Chapter Admin)
- **Role Target**: Branch / Location Administrator (e.g. Kathmandu Chapter Head)
- **Purpose**: High-level operational command center for chapter admins to view active members, upcoming cultural gatherings, recent activity streams, and access quick management actions.

## 2. Technical File Mapping
- **File Location**: [admin_dashboard_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/location_admin/dashboard/presentation/admin_dashboard_screen.dart)
- **Route Path**: `AppConstants.adminDashboard` (`/admin/dashboard`)
- **Widget Type**: `StatelessWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Kathmandu Branch Admin')
└── SingleChildScrollView
    └── Column
        ├── Greeting Section:
        │   ├── Header: "Namaste, Administrator" (AppText.h1)
        │   └── Subtitle: "Manage the Kathmandu chapter's activities..."
        ├── Metric Grid (GridView.count 2x2):
        │   ├── Metric 1: Total Members (1,248) [Icons.people_rounded - Primary Blue]
        │   ├── Metric 2: Active Members (856) [Icons.check_circle_rounded - Green]
        │   ├── Metric 3: Upcoming Events (12) [Icons.event_rounded - Accent]
        │   └── Metric 4: Past Events (342) [Icons.history_rounded - Gold]
        ├── Quick Actions Section:
        │   ├── Header: "Quick Actions"
        │   └── Action Row:
        │       ├── Tile 1: "Approve Members" (Navigates to /admin/members)
        │       └── Tile 2: "Create Event" (Navigates to /admin/events)
        └── Recent Activities Section:
            ├── Header Row: "Recent Activities" + "View All" TextButton
            └── Activities Container:
                ├── Activity Item 1: New Member Registration (Rajesh Agrawal)
                ├── Divider
                └── Activity Item 2: Event RSVP Update (Teej Festival 2026)
```

## 4. Components & Tokens Used
- `NASAppBar`
- `_AdminMetricCard` (Custom metric tile)
- `_ActionTile` (Primary colored touch target)
- `_ActivityItem` (Avatar icon + timestamp + description line)
- `AppColors.primary`, `AppColors.accent`, `AppColors.gold`, `AppColors.cardBackground`
- `AppSpacing.md`, `AppSpacing.lg`, `AppSpacing.xl`

## 5. Data & Logic Workflow
- **Data Source**: Hardcoded metrics & activity items (Needs connection to Supabase `profiles`, `events`, `activity_logs` tables).
- **Navigation Shortcuts**:
  - `context.go('/admin/members')`
  - `context.go('/admin/events')`

## 6. Redesign & UI Upgrade Roadmap
- **Metrics Grid**: Upgrade static metric boxes into glassmorphic cards with animated number counters and live sparkline mini-charts.
- **Activity Feed**: Add filter tabs (All, Registrations, Events, Finance) and live polling/realtime badge counters.
- **Quick Action Bar**: Transform into a horizontal floating action strip with quick drawer creation modals (Quick Add Member, Quick Event, Broadcast Announcement).
- **Branch Switcher**: Add top branch switcher for multi-chapter admins.
