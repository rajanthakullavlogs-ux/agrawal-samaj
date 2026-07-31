import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initializes and provides access to the Supabase client.
///
/// Must be called in [main] before [runApp].
/// Credentials are read from `.env` via flutter_dotenv.
class SupabaseConfig {
  SupabaseConfig._();

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    final url = dotenv.env['SUPABASE_URL'] ?? 'https://npsyuljugnauvsfwetcp.supabase.co';
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? 'sb_publishable_h1b-2UAT56Ju8KEZVIyKhw_9AbNZ0lU';
    await Supabase.initialize(
      url: url.isNotEmpty ? url : 'https://npsyuljugnauvsfwetcp.supabase.co',
      publishableKey: key.isNotEmpty ? key : 'sb_publishable_h1b-2UAT56Ju8KEZVIyKhw_9AbNZ0lU',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  // ── Storage bucket names ─────────────────────────────────────
  static const String eventPostersBucket = 'event-posters';
  static const String galleryBucket = 'gallery';
  static const String avatarsBucket = 'avatars';
  static const String businessDocsBucket = 'business-docs';

  /// Returns a public URL for a file in the given bucket.
  static String getPublicUrl(String bucket, String path) {
    return client.storage.from(bucket).getPublicUrl(path);
  }
}
