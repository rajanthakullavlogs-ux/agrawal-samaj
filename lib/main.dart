import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'core/constants.dart';
import 'core/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(
    const ProviderScope(
      child: NASApp(),
    ),
  );
}

/// Custom RootBackButtonDispatcher intercepting Android system back button/gesture.
class NASDoubleBackDispatcher extends RootBackButtonDispatcher {
  DateTime? _lastBackPressTime;

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    final activeContext = primaryFocus?.context;
    final handled = await super.invokeCallback(defaultValue);
    if (handled) {
      return true; // Inner navigator popped a route
    }

    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;

      if (activeContext != null && activeContext.mounted) {
        ScaffoldMessenger.of(activeContext).clearSnackBars();
        ScaffoldMessenger.of(activeContext).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return true; // Intercept & block single press exit
    }

    return false; // Confirmed 2nd back press within 2s -> Exit app
  }
}

class NASApp extends ConsumerStatefulWidget {
  const NASApp({super.key});

  @override
  ConsumerState<NASApp> createState() => _NASAppState();
}

class _NASAppState extends ConsumerState<NASApp> {
  late final NASDoubleBackDispatcher _backButtonDispatcher;

  @override
  void initState() {
    super.initState();
    _backButtonDispatcher = NASDoubleBackDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: NASTheme.light,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      backButtonDispatcher: _backButtonDispatcher,
      debugShowCheckedModeBanner: false,
    );
  }
}
