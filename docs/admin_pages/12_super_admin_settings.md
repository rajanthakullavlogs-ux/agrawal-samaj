# Super Admin Settings Page (`/super-admin/settings`)

## 1. Page Overview & Purpose
- **Page Title**: Super Admin Settings (Global Settings)
- **Role Target**: Super Administrator
- **Purpose**: Manage core system parameters of the Nepal Agrawal Samaj portal, administrative hierarchy, platform defaults, system security, role-based permissions, and global notification controls.

## 2. Technical File Mapping
- **File Location**: [settings_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/super_admin/settings/presentation/settings_screen.dart)
- **Route Path**: `AppConstants.superAdminSettings` (`/super-admin/settings`)
- **Widget Type**: `StatelessWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Super Admin Settings')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Header Section:
│       │   ├── Title: "Super Admin Settings"
│       │   └── Subtext: "Configure the core parameters of the Nepal Agrawal Samaj portal..."
│       ├── Module 1 Card (Admin Management):
│       │   └── NASCard:
│       │       ├── Header Row: Icon (admin_panel_settings_outlined) + Badge ("Coming Soon")
│       │       ├── Module Title: "Admin Management"
│       │       └── Subtext: "Control who has access to the control panel..."
│       └── Module 2 Card (Roles & Permissions):
│           └── NASCard:
│               ├── Header Row: Icon (security_outlined) + Badge ("Q4 2024")
│               ├── Module Title: "Roles & Permissions"
│               └── Subtext: "Define granular permission sets for different community roles..."
└── BottomNavigationBar: NASBottomNav (Index 3: Settings active tab)
```

## 4. Components & Tokens Used
- `NASAppBar`
- `NASCard`
- `NASBadge`
- `NASContentWidth`
- `NASBottomNav`

## 5. Redesign & UI Upgrade Roadmap
- **Role & RBAC Matrix Editor**: Add interactive permission matrix grid (Super Admin, Location Admin, Moderator, Member) with toggle switches per feature.
- **Admin User Management Table**: Add live table listing all active super admins & location admins with "Invite Admin" button and 2FA status indicator.
- **System Maintenance Mode Switch**: Add toggle for platform maintenance mode with custom banner message editor.
- **Database Backup & Migration Manager**: Add buttons for manual Supabase database backup download & schema migration log inspection.
