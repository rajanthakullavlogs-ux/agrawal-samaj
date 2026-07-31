# Gallery Management Page (`/admin/gallery`)

## 1. Page Overview & Purpose
- **Page Title**: Gallery Management (Location Admin)
- **Role Target**: Branch / Location Administrator
- **Purpose**: Manage community event photo albums, preserve cultural heritage through photography, upload new media, organize album archives, and view storage metrics.

## 2. Technical File Mapping
- **File Location**: [gallery_management_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/location_admin/gallery_management/presentation/gallery_management_screen.dart)
- **Route Path**: `AppConstants.adminGallery` (`/admin/gallery`)
- **Widget Type**: `StatelessWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Gallery Management')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Header Section:
│       │   ├── Title: "Gallery Management" (NASTypography.headlineMd)
│       │   └── Subtext: "Manage community event albums, preserve cultural heritage..."
│       ├── Primary Action Row:
│       │   ├── Secondary Button: "Upload Photos" (Cloud upload icon)
│       │   └── Primary Button: "Create Album" (+ icon)
│       ├── Stat Cards Grid (2x2):
│       │   ├── Metric 1: TOTAL ALBUMS (42) [photo_library_outlined]
│       │   ├── Metric 2: TOTAL PHOTOS (1,284) [image_outlined]
│       │   ├── Metric 3: STORAGE USED (84%) [sd_card_outlined]
│       │   └── Metric 4: SHARED VIEWS (15.2k) [visibility_outlined]
│       ├── Recent Albums Header:
│       │   ├── Title: "Recent Albums"
│       │   └── Sort Dropdown: "Sort by: Date / Sort by: Views"
│       └── Recent Albums List:
│           └── ListView.separated -> NASCard
│               ├── Album 1: Maha Shivaratri 2024 (Feb 15, 2024 • Cultural • 124 photos)
│               ├── Album 2: Executive Committee Meet (Jan 22, 2024 • Admin • 45 photos)
│               └── Album 3: Vasant Panchami Celebration (Feb 02, 2024 • Community • 210 photos)
└── BottomNavigationBar: NASBottomNav (Index 0: Dashboard active tab context)
```

## 4. Components & Tokens Used
- `NASAppBar`
- `NASPrimaryButton`, `NASSecondaryButton`
- `NASStatCard`
- `NASCard`
- DropdownButton (Sort selector)
- `NASBottomNav`

## 5. Media & Asset Handling
- Photo count overlay badge on cover image stack.
- Triple dot contextual menu button per album card.

## 6. Redesign & UI Upgrade Roadmap
- **Drag-and-Drop Uploader**: Add visual drag-and-drop zone with progress bars, batch image processing, and tags editor.
- **Masonry Grid Layout**: Upgrade album list into responsive masonry image tiles with lazy image caching and lightbox preview.
- **Storage Usage Bar**: Add interactive storage gauge with breakdown (High-Res Images, Videos, Documents).
- **Privacy & Visibility Controls**: Add toggle per album (Public, Members Only, Admin Only).
