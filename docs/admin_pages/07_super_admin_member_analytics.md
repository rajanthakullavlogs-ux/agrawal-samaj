# Member Analytics Page (`/super-admin/analytics`)

## 1. Page Overview & Purpose
- **Page Title**: Member Distribution Analytics (Super Admin)
- **Role Target**: Super Administrator / Data Analyst
- **Purpose**: Provide comprehensive nationwide demographic visualizations, track member growth by province, analyze membership registration trends over date ranges, and review regional coverage.

## 2. Technical File Mapping
- **File Location**: [member_analytics_screen.dart](file:///Users/rajanthakulla/Desktop/agrawal%20samaj/lib/features/super_admin/analytics/presentation/member_analytics_screen.dart)
- **Route Path**: `AppConstants.superAdminAnalytics` (`/super-admin/analytics`)
- **Widget Type**: `StatelessWidget`

## 3. UI Structure & Component Breakdown
```
Scaffold
├── AppBar: NASAppBar(title: 'Member Analytics')
├── Body: SingleChildScrollView
│   └── NASContentWidth
│       ├── Header Section:
│       │   ├── Title: "Member Distribution Analytics"
│       │   └── Subtext: "Comprehensive visualization of the community network..."
│       ├── Date Range Filter Card:
│       │   └── NASCard: "01/01/2024 to 31/12/2024" + "Apply Filter" Primary Button
│       ├── Nationwide Stat Cards:
│       │   ├── Metric 1: TOTAL MEMBERS (12,842) [↗ +12% from last year]
│       │   ├── Metric 2: NEW REGISTRATIONS (432) [Current month]
│       │   └── Metric 3: ACTIVE PROVINCES (7) [Covering all Nepal]
│       ├── Province Distribution Section:
│       │   ├── Section Title: "Province Member Distribution"
│       │   └── Chart Card:
│       │       └── NASCard wrapping fl_chart BarChart:
│       │           ├── Bagmati: 2,800
│       │           ├── Madhesh: 2,100
│       │           ├── Koshi: 1,600
│       │           ├── Gandaki: 1,200
│       │           └── Lumbini: 900
│       └── Footer: NASFooter
└── BottomNavigationBar: NASBottomNav (Index 1: Analytics active tab)
```

## 4. Components & Libraries Used
- `fl_chart` (`BarChart`, `BarChartGroupData`, `BarChartRodData`, `FlTitlesData`)
- `NASAppBar`
- `NASCard`
- `NASStatCard`
- `NASPrimaryButton`
- `NASBottomNav`

## 5. Data & Visualization Details
- **Chart Data**: Bars representing Bagmati, Madhesh, Koshi, Gandaki, and Lumbini provinces.
- **Date Filter State**: Single touch action triggering toast feedback.

## 6. Redesign & UI Upgrade Roadmap
- **Interactive Chart Switcher**: Add toggle buttons between Bar Chart, Pie Chart (Demographics by Age/Gender), and Line Chart (Monthly Growth Rate).
- **Provisional Drilldown**: Allow clicking on any province bar to drill down into district & municipality branch breakdowns.
- **Export Data Sheet**: Add buttons for "Export PDF Summary" and "Download Raw Excel Data".
- **Dynamic Date Picker Range**: Replace text date range with an interactive dual-date range picker modal.
