# Branch Settings Page (`/admin/settings`)

## 1. Page Overview & Purpose
- **Page Title**: Branch Settings (Location Admin)
- **Role Target**: Branch / Location Administrator
- **Purpose**: Configure chapter profiles, mission statements, contact details, map location addresses, and branch leadership bio and photo.

## 2. Technical File Mapping
- **File Location**: [branch_settings_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/location_admin/branch_settings/presentation/branch_settings_screen.dart)
- **Route Path**: `AppConstants.adminSettings` (`/admin/settings`)
- **Widget Type**: `StatefulWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Branch Settings')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Header Section:
│       │   ├── Title: "Branch Settings"
│       │   └── Subtext: "Manage the Kathmandu Central Branch profile..."
│       ├── Section 1 Card (Branch Description):
│       │   ├── Header Icon + Title: "Branch Description"
│       │   ├── Input 1: Branch Name ("Kathmandu Central Branch")
│       │   └── Input 2: Mission Statement (Multiline text area)
│       ├── Section 2 Card (Contact Details):
│       │   ├── Header Icon + Title: "Contact Details"
│       │   ├── Input 1: Primary Phone ("+977-1-4423XXX")
│       │   ├── Input 2: Official Email ("kathmandu@nepalagrawal.org")
│       │   └── Input 3: Website ("https://kathmandu.agrawalsamaj.org.np")
│       ├── Section 3 Card (Location Info):
│       │   ├── Header Icon + Title: "Location Info"
│       │   ├── Map Preview Box: Interactive map placeholder with icon
│       │   └── Input 1: Address ("Kamaladi, Kathmandu, Ward No. 28")
│       ├── Section 4 Card (Leader Info):
│       │   ├── Header Icon + Title: "Leader Info"
│       │   ├── Leader Avatar: CircleAvatar with camera upload badge
│       │   ├── Input 1: Full Name ("Shree Ram Agrawal")
│       │   └── Input 2: Brief Bio (Multiline bio area)
│       └── Bottom Action Buttons:
│           ├── Secondary Button: "Discard"
│           └── Primary Button: "Save Changes" (Save icon)
└── Footer: NASFooter
```

## 4. Components & Tokens Used
- `NASAppBar`
- `NASCard`
- `NASInputField` (supports single-line & multiline `maxLines`)
- `NASPrimaryButton`, `NASSecondaryButton`
- `NASToast`

## 5. Form Controllers & State
- `_branchNameController`
- `_missionController`
- `_phoneController`
- `_emailController`
- `_websiteController`
- `_addressController`
- `_leaderNameController`
- `_leaderBioController`
- Save action (`_saveSettings`): Triggers toast & persists updates.

## 6. Redesign & UI Upgrade Roadmap
- **Interactive Map Picker**: Replace map placeholder with live Google Maps / OpenStreetMap location picker with pin placement & GPS auto-fill.
- **Image Cropper & Upload**: Add live photo upload dialog with cropping for branch leader avatar and chapter banner background.
- **Social Media Links Widget**: Add expandable section for Facebook, Instagram, YouTube, and WhatsApp support links.
- **Form Change Detection**: Add unsaved changes confirmation modal on navigate back.
