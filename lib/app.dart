import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'I Wish',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter.config(),
    );
  }
}
