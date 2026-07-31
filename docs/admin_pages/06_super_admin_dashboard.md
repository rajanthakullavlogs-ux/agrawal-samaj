# Super Admin Strategic Dashboard (`/super-admin/dashboard`)

## 1. Page Overview & Purpose
- **Page Title**: Super Admin Portal (Strategic Dashboard)
- **Role Target**: Super Administrator / Central Board Executive
- **Purpose**: High-level national command center to monitor all 18 active Samaj chapters across Nepal, inspect nationwide member growth metrics, access core administrative modules, create central events, and export executive reports.

## 2. Technical File Mapping
- **File Location**: [super_admin_dashboard_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/super_admin/dashboard/presentation/super_admin_dashboard_screen.dart)
- **Route Path**: `AppConstants.superAdminDashboard` (`/super-admin/dashboard`)
- **Widget Type**: `StatelessWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Super Admin Portal')
└── SingleChildScrollView
    └── Column
        ├── Top Header:
        │   ├── Tag: "ADMINISTRATOR PORTAL" (Gold, Uppercase)
        │   └── Title: "Strategic Dashboard" (AppText.h1)
        ├── Action Buttons Row:
        │   ├── Primary Button: "Create Event" (+ icon) -> Toast trigger
        │   └── Outlined Button: "Export Reports" (Download icon) -> Toast trigger
        ├── Nationwide Metric Cards (Vertical List):
        │   ├── Metric 1: Total Active Chapters (18) [↗ 2 added this month]
        │   ├── Metric 2: Total Registered Members (5,200+) [↗ +12% growth in 2026]
        │   └── Metric 3: Total Events Organized (130+) [↗ 24 upcoming across Nepal]
        └── Management Modules Section:
            ├── Header: "Management Modules" (AppText.h2)
            ├── Module 1: Member Analytics ("View demographics & growth trends" -> /super-admin/analytics)
            ├── Module 2: Locations Management ("Manage 18 regional chapters" -> /super-admin/locations)
            ├── Module 3: Centralized Events ("Oversee nationwide event calendar" -> /super-admin/events)
            └── Module 4: Centralized Gallery ("Approve & categorize album media" -> /super-admin/gallery)
```

## 4. Components & Tokens Used
- `NASAppBar`
- `_SuperMetricTile` (Custom card with colored avatar background & trend indicator)
- `_moduleTile` (Clickable module tile with arrow navigation)
- `AppColors.gold`, `AppColors.primary`, `AppColors.accent`
- `AppRadius.pill`, `AppRadius.md`

## 5. Navigation & Routing Links
- Member Analytics -> `context.go('/super-admin/analytics')`
- Locations Management -> `context.go('/super-admin/locations')`
- Centralized Events -> `context.go('/super-admin/events')`
- Centralized Gallery -> `context.go('/super-admin/gallery')`

## 6. Redesign & UI Upgrade Roadmap
- **Executive KPI Row**: Redesign into animated gradient hero metrics with monthly variance toggles.
- **Nepal Interactive Map Widget**: Replace text metrics with an interactive vector map of Nepal highlighting chapter density per province.
- **System Audit Log Stream**: Add live security & administrative audit log section (e.g. "Admin X approved Birgunj Branch").
- **Quick Command Palette**: Add floating command palette (`Cmd+K` / search bar) for instant navigation to any chapter or admin setting.
