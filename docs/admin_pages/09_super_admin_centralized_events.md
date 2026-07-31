# Centralized Events Overview Page (`/super-admin/events`)

## 1. Page Overview & Purpose
- **Page Title**: Centralized Events Overview (Super Admin)
- **Role Target**: Super Administrator
- **Purpose**: Provide central board executives with nationwide oversight of all cultural, business, youth, and health events across all 18 regional chapters in Nepal.

## 2. Technical File Mapping
- **File Location**: [centralized_events_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/super_admin/centralized_events_screen.dart)
- **Route Path**: `AppConstants.superAdminEvents` (`/super-admin/events`)
- **Widget Type**: `StatelessWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Centralized Events')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Header Section:
│       │   ├── Title: "Centralized Events Overview"
│       │   └── Subtext: "Oversee all events from all 14 regional chapters across Nepal."
│       └── All Chapters Activity Card:
│           └── NASCard:
│               ├── Card Header: "All Chapters Activity"
│               └── Description: "24 upcoming events scheduled this quarter across Bagmati, Madhesh, Koshi, Gandaki, and Lumbini provinces."
└── Footer: NASFooter
```

## 4. Components & Tokens Used
- `NASAppBar`
- `NASCard`
- `NASContentWidth`
- `NASFooter`

## 5. Redesign & UI Upgrade Roadmap
- **Nationwide Master Event Calendar**: Upgrade from static summary placeholder to an interactive master calendar displaying events across all 18 branches with color-coded province tags.
- **National Event Approval Pipeline**: Add approval workflow tab for local branch events requiring central board sanction or financial sponsorship.
- **Cross-Branch RSVP Analytics**: Add comparative charts showing participation rates per chapter.
- **Export National Calendar**: Add "Sync to Google Calendar / Outlook" and "Download PDF Event Schedule" buttons.
