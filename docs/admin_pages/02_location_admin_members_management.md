# Members Management Page (`/admin/members`)

## 1. Page Overview & Purpose
- **Page Title**: Members Management (Location Admin)
- **Role Target**: Branch / Location Administrator
- **Purpose**: Manage chapter membership applications, review pending member registrations, search members by name/ID, filter status (Active, Pending, Inactive), and approve or edit member credentials.

## 2. Technical File Mapping
- **File Location**: [members_management_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/location_admin/members/presentation/members_management_screen.dart)
- **Route Path**: `AppConstants.adminMembers` (`/admin/members`)
- **Widget Type**: `ConsumerStatefulWidget` (Riverpod ready)

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Members Management')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Search Bar: NASInputField (hint: 'Search members by name or ID...')
│       ├── Filter & Action Row:
│       │   ├── Status Selector: NASSelectField (All Status, Active, Pending, Inactive)
│       │   └── Primary Button: "Add Member" (+ icon)
│       ├── Pending Applications Banner:
│       │   └── NASCard (Gold Accent): "12 New Applications Pending review for Kathmandu chapter" + "View List" Button
│       ├── Members List:
│       │   └── ListView.separated -> NASMemberCard
│       │       ├── Member 1: Rahul Agrawal (ID: NAS-4492, Lifetime Member, ACTIVE)
│       │       ├── Member 2: Sneha Mittal (ID: NAS-9021, Standard Member, PENDING)
│       │       ├── Member 3: Deepak Goyal (ID: NAS-1205, Trustee, ACTIVE)
│       │       └── Member 4: Vikram Bansal (ID: NAS-5510, Standard Member, INACTIVE)
│       └── Footer: NASFooter
└── BottomNavigationBar: NASBottomNav (Index 1: Members active tab)
```

## 4. Components & Tokens Used
- `NASAppBar`
- `NASInputField`
- `NASSelectField`
- `NASPrimaryButton`, `NASSecondaryButton`
- `NASCard` (Gold Accent variant)
- `NASMemberCard`
- `NASToast`
- `NASBottomNav`

## 5. Modal Drawers & Dialogs
- **Member Detail Bottom Drawer (`_showMemberDrawer`)**:
  - Displays full member name, ID, member type.
  - Action Button 1: "Approve / Edit" -> updates status & triggers success toast.
  - Action Button 2: "Close" -> dismisses drawer.

## 6. Redesign & UI Upgrade Roadmap
- **Data Table / Grid Toggle**: Support both compact list view and detailed data table view with multi-column sorting (Name, Join Date, Membership Type, Status, Actions).
- **Batch Actions**: Add multi-select checkboxes for batch approval, status update, or export (CSV/Excel/PDF).
- **Advanced Filters**: Add filter drawers for Membership Type (Lifetime, Trustee, Standard, Business), Registration Date Range, and Payment Verification status.
- **Member Profile Modal**: Upgrade bottom drawer into a tabbed profile drawer (Personal Info, Family Tree, Payment Receipts, Attendance Record).
