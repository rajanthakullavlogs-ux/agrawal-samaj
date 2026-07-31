import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';
import '../features/about/presentation/about_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/profile_screen.dart';
import '../features/auth/presentation/profile_edit_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/contact/presentation/contact_screen.dart';
import '../features/events/presentation/event_detail_screen.dart';
import '../features/events/presentation/events_list_screen.dart';
import '../features/gallery/presentation/gallery_detail_screen.dart';
import '../features/gallery/presentation/gallery_list_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/locations/presentation/location_profile_screen.dart';
import '../features/locations/presentation/locations_list_screen.dart';
import '../features/membership/business_registration/presentation/business_registration_screen.dart';
import '../features/membership/normal_registration/presentation/normal_registration_screen.dart';
import '../features/membership/presentation/membership_selector_screen.dart';
import '../features/location_admin/branch_settings/presentation/branch_settings_screen.dart';
import '../features/location_admin/dashboard/presentation/admin_dashboard_screen.dart';
import '../features/location_admin/events_management/presentation/events_management_screen.dart';
import '../features/location_admin/gallery_management/presentation/gallery_management_screen.dart';
import '../features/location_admin/members/presentation/members_management_screen.dart';
import '../features/super_admin/analytics/presentation/analytics_coming_soon_screen.dart';
import '../features/super_admin/analytics/presentation/member_analytics_screen.dart';
import '../features/super_admin/centralized_events_screen.dart';
import '../features/super_admin/centralized_gallery_screen.dart';
import '../features/super_admin/dashboard/presentation/super_admin_dashboard_screen.dart';
import '../features/super_admin/locations_management/presentation/locations_management_screen.dart';
import '../features/super_admin/settings/presentation/settings_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

class _UnauthorizedScreen extends StatelessWidget {
  const _UnauthorizedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Denied')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'You do not have permission to access this page.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Router Provider ────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  final profileAsync = ref.watch(currentProfileProvider);

  return GoRouter(
    initialLocation: AppConstants.home,
    debugLogDiagnostics: false,

    redirect: (context, state) {
      final path = state.uri.path;
      final profile = profileAsync.valueOrNull;
      final isLoggedIn = profile != null;

      // Admin routes require login + correct role
      if (path.startsWith('/admin') || path.startsWith('/super-admin')) {
        if (!isLoggedIn) return AppConstants.login;
        if (profile.isMember) return AppConstants.unauthorized;
        if (path.startsWith('/super-admin') && !profile.isSuperAdmin) {
          return AppConstants.unauthorized;
        }
      }

      // If logged in and trying to access login/signup → go to profile
      if (isLoggedIn &&
          (path == AppConstants.login || path == AppConstants.signup)) {
        return AppConstants.profile;
      }

      return null;
    },

    routes: [
      // ── Public Routes (bottom nav tabs use go) ─────────────
      GoRoute(
        path: AppConstants.home,
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.about,
        builder: (_, _) => const AboutScreen(),
      ),
      GoRoute(
        path: AppConstants.events,
        builder: (_, _) => const EventsListScreen(),
      ),
      GoRoute(
        path: AppConstants.eventDetail,
        builder: (_, state) => EventDetailScreen(
          eventId: state.pathParameters['id'] ?? 'ev-1',
        ),
      ),
      GoRoute(
        path: AppConstants.gallery,
        builder: (_, _) => const GalleryListScreen(),
      ),
      GoRoute(
        path: AppConstants.galleryDetail,
        builder: (_, state) => GalleryDetailScreen(
          galleryId: state.pathParameters['id'] ?? 'gal-1',
        ),
      ),
      GoRoute(
        path: AppConstants.locations,
        builder: (_, _) => const LocationsListScreen(),
      ),
      GoRoute(
        path: AppConstants.locationProfile,
        builder: (_, state) => LocationProfileScreen(
          locationId: state.pathParameters['id'] ?? 'loc-1',
        ),
      ),
      GoRoute(
        path: AppConstants.membershipSelector,
        builder: (_, _) => const MembershipSelectorScreen(),
      ),
      GoRoute(
        path: AppConstants.normalRegistration,
        builder: (_, _) => const NormalRegistrationScreen(),
      ),
      GoRoute(
        path: AppConstants.businessRegistration,
        builder: (_, _) => const BusinessRegistrationScreen(),
      ),
      GoRoute(
        path: AppConstants.contact,
        builder: (_, _) => const ContactScreen(),
      ),
      GoRoute(
        path: AppConstants.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.signup,
        builder: (_, _) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppConstants.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppConstants.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: '${AppConstants.profile}/edit',
        builder: (_, _) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: AppConstants.unauthorized,
        builder: (_, _) => const _UnauthorizedScreen(),
      ),

      // ── Location Admin Routes ──────────────────────────────
      GoRoute(
        path: AppConstants.adminDashboard,
        builder: (_, _) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppConstants.adminMembers,
        builder: (_, _) => const MembersManagementScreen(),
      ),
      GoRoute(
        path: AppConstants.adminEvents,
        builder: (_, _) => const EventsManagementScreen(),
      ),
      GoRoute(
        path: AppConstants.adminGallery,
        builder: (_, _) => const GalleryManagementScreen(),
      ),
      GoRoute(
        path: AppConstants.adminSettings,
        builder: (_, _) => const BranchSettingsScreen(),
      ),

      // ── Super Admin Routes ─────────────────────────────────
      GoRoute(
        path: AppConstants.superAdminDashboard,
        builder: (_, _) => const SuperAdminDashboardScreen(),
      ),
      GoRoute(
        path: AppConstants.superAdminAnalytics,
        builder: (_, _) => const MemberAnalyticsScreen(),
      ),
      GoRoute(
        path: AppConstants.superAdminLocations,
        builder: (_, _) => const LocationsManagementScreen(),
      ),
      GoRoute(
        path: AppConstants.superAdminEvents,
        builder: (_, _) => const CentralizedEventsScreen(),
      ),
      GoRoute(
        path: AppConstants.superAdminGallery,
        builder: (_, _) => const CentralizedGalleryScreen(),
      ),
      GoRoute(
        path: AppConstants.superAdminComingSoon,
        builder: (_, _) => const AnalyticsComingSoonScreen(),
      ),
      GoRoute(
        path: AppConstants.superAdminSettings,
        builder: (_, _) => const SettingsScreen(),
      ),
    ],
  );
});
