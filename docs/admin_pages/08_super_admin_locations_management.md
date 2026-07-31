# Locations Management Page (`/super-admin/locations`)

## 1. Page Overview & Purpose
- **Page Title**: Manage Locations (Super Admin)
- **Role Target**: Super Administrator
- **Purpose**: Manage all 18 regional branch chapters and local units across Nepal, inspect leader assignments, review member counts per branch, filter by province/region, add new branches, and reassign branch leadership.

## 2. Technical File Mapping
- **File Location**: [locations_management_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/super_admin/locations_management/presentation/locations_management_screen.dart)
- **Route Path**: `AppConstants.superAdminLocations` (`/super-admin/locations`)
- **Widget Type**: `StatefulWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Locations Management')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Top Header Row:
│       │   ├── Subtitle: "SUPER ADMIN DASHBOARD"
│       │   ├── Title: "Manage Locations"
│       │   └── Primary Button: "Add Location" (+ icon) -> Toast trigger
│       ├── Search & Filter Section:
│       │   ├── Search Input: NASInputField (hint: 'Search by branch name, leader...')
│       │   └── Region Filter Chips (Horizontal scroll):
│       │       ├── All Regions (Selected)
│       │       ├── Province 1
│       │       ├── Bagmati
│       │       └── Lumbini
│       └── Branch Locations List:
│           └── ListView.separated -> NASCard (Gold Accent):
│               ├── Branch 1: Kathmandu Central (Leader: Shri Rajesh Agrawal, 1,240 Members, 42 Events, Status: Active)
│               ├── Branch 2: Biratnagar Branch (Leader: Smt. Sarita Agrawal, 856 Members, 18 Events, Status: Active)
│               └── Branch 3: Butwal Unit (Leader: Shri Pawan Gupta, 230 Members, 0 Events, Status: Inactive)
└── BottomNavigationBar: NASBottomNav (Index 2: Locations active tab)
```

## 4. Components & Tokens Used
- `NASAppBar`
- `NASPrimaryButton`, `NASSecondaryButton`
- `NASInputField`
- `FilterChip`
- `NASCard` (Gold Accent variant)
- `NASBadge` (`fromStatus` builder)
- `NASBottomNav`

## 5. Modal Drawers & Dialogs
- **Location Details Bottom Sheet (`_showLocationDrawer`)**:
  - Displays Branch Name, Province.
  - Metrics Card: Total Members count, Branch Leader Name.
  - Action Button 1: "Reassign Leader" -> Triggers reassignment workflow.
  - Action Button 2: "Close" -> Dismisses drawer.

## 6. Redesign & UI Upgrade Roadmap
- **Interactive Map Split View**: Add dual layout view (List View / Interactive Nepal Map View with clickable branch pins).
- **Branch Creation Dialog Wizard**: Add multi-step branch onboarding dialog (Location & Address -> Boundary/Ward -> Appoint Branch Leader -> Initialize Admin Account).
- **Branch Health Score Badge**: Include health indicator based on active members vs events conducted ratio.
- **Bulk Leadership Audit Table**: Add tab for reviewing all 18 branch leaders and their terms of office.
