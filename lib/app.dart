import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    // Initialize app state when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appNotifierProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp.router(
      title: 'I Wish',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Router Configuration
      routerConfig: _appRouter.config(),

      // Performance Optimizations
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            // Option 2: Image background (uncomment to use)
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
              // Adjust opacity to keep content readable
            ),
          ),
          child: MediaQuery(
            // Prevent font scaling beyond reasonable limits
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(context).textScaler.clamp(
                    minScaleFactor: 0.8,
                    maxScaleFactor: 1.3,
                  ),
            ),
            child: child!,
          ),
        );
      },

      // Localization (if needed in future)
      supportedLocales: const [
        Locale('en', 'US'),
      ],

      // Accessibility
      showSemanticsDebugger: false,
    );
  }
}
