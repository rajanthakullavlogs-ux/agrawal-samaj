/// App-wide constants: route paths, table names, and configuration.
class AppConstants {
  AppConstants._();

  static const String appName = 'Nepal Agrawal Samaj';
  static const String appTagline = 'Heritage & Unity';

  // ── Route Paths ──────────────────────────────────────────────
  static const String home = '/';
  static const String about = '/about';
  static const String events = '/events';
  static const String eventDetail = '/events/:id';
  static const String gallery = '/gallery';
  static const String galleryDetail = '/gallery/:id';
  static const String locations = '/locations';
  static const String locationProfile = '/locations/:id';
  static const String membershipSelector = '/membership';
  static const String normalRegistration = '/membership/normal';
  static const String businessRegistration = '/membership/business';
  static const String contact = '/contact';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';
  static const String unauthorized = '/unauthorized';

  // Location Admin routes
  static const String adminDashboard = '/admin';
  static const String adminMembers = '/admin/members';
  static const String adminEvents = '/admin/events';
  static const String adminGallery = '/admin/gallery';
  static const String adminSettings = '/admin/settings';

  // Super Admin routes
  static const String superAdminDashboard = '/super-admin';
  static const String superAdminAnalytics = '/super-admin/analytics';
  static const String superAdminLocations = '/super-admin/locations';
  static const String superAdminEvents = '/super-admin/events';
  static const String superAdminGallery = '/super-admin/gallery';
  static const String superAdminComingSoon = '/super-admin/coming-soon';
  static const String superAdminSettings = '/super-admin/settings';

  // ── Supabase Table Names ─────────────────────────────────────
  static const String locationsTable = 'locations';
  static const String profilesTable = 'profiles';
  static const String businessProfilesTable = 'business_profiles';
  static const String eventsTable = 'events';
  static const String eventRegistrationsTable = 'event_registrations';
  static const String galleriesTable = 'galleries';
  static const String galleryPhotosTable = 'gallery_photos';
  static const String contactMessagesTable = 'contact_messages';
  static const String paymentsTable = 'payments';
  static const String activityLogTable = 'activity_log';
  static const String orgStatsView = 'org_stats';

  // ── User Roles ───────────────────────────────────────────────
  static const String roleMember = 'member';
  static const String roleLocationAdmin = 'location_admin';
  static const String roleSuperAdmin = 'super_admin';

  // ── Membership Statuses ──────────────────────────────────────
  static const String statusPending = 'pending';
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';

  // ── Event Statuses ───────────────────────────────────────────
  static const String eventUpcoming = 'upcoming';
  static const String eventPast = 'past';
  static const String eventCancelled = 'cancelled';

  // ── Breakpoints ──────────────────────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}
