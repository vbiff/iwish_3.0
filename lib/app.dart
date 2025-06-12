import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      routerConfig: AppRouter().config(),

      // Performance Optimizations
      builder: (context, child) {
        return MediaQuery(
          // Prevent font scaling beyond reasonable limits
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 1.3,
                ),
          ),
          child: child!,
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
