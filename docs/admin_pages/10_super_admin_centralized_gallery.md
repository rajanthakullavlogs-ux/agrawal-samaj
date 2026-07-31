# Centralized Gallery Page (`/super-admin/gallery`)

## 1. Page Overview & Purpose
- **Page Title**: Centralized Photo Archive (Super Admin)
- **Role Target**: Super Administrator / Cultural Historian
- **Purpose**: National archive repository for super admins to oversee cultural photo collections, event galleries, historical Samaj documents, and media assets submitted by all regional chapters.

## 2. Technical File Mapping
- **File Location**: [centralized_gallery_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/super_admin/centralized_gallery_screen.dart)
- **Route Path**: `AppConstants.superAdminGallery` (`/super-admin/gallery`)
- **Widget Type**: `StatelessWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Centralized Gallery')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Header Section:
│       │   ├── Title: "Centralized Photo Archive"
│       │   └── Subtext: "National archive of cultural photos, event galleries..."
│       └── National Photo Vault Card:
│           └── NASCard:
│               ├── Card Header: "National Photo Vault"
│               └── Description: "Over 12,000 photos stored securely across all branch chapters."
└── Footer: NASFooter
```

## 4. Components & Tokens Used
- `NASAppBar`
- `NASCard`
- `NASContentWidth`
- `NASFooter`

## 5. Redesign & UI Upgrade Roadmap
- **Media Moderation Queue**: Add pending media approval grid for photos uploaded by branch admins before publishing to the public gallery.
- **AI Tagging & Face Recognition**: Add auto-tagging for community leaders, events, and categories.
- **High-Res Media Vault**: Support downloading original uncompressed archive zip files for printing & publications.
- **Historical Timeline View**: Add visual timeline slider allowing users to browse archives by decade (e.g. 1990s, 2000s, 2010s, 2020s).
