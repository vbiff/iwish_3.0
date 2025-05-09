import 'package:flutter/material.dart';

import '../../presentation/auth/authentication/auth_gate.dart';

abstract class AppRoutes {
  static const authGate = 'authGate';
  static const mainScreen = '/';
  static const authScreen = 'auth';
  static const profileScreen = 'profile';

  static Map<String, WidgetBuilder> routes = {
    AppRoutes.authGate: (_) => const AuthGate(),
    // AppRoutes.mainScreen: (_) => const MainScreenView(),
    // AppRoutes.authScreen: (_) => const AuthScreeenView(),
    // AppRoutes.profileScreen: (_) => const ProfileScreenView(),
  };

//--------------------------------------------------------//

  ///Go to MainScreeenPage and clear the stack
  static void goRootAsMainScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.mainScreen, (route) => false);
  }

  ///Go to AuthScreenView and clear the stack
  static void goRootAsAuthScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.authScreen, (route) => false);
  }

  ///Go to AuthGateScreenView and clear the stack
  static void goRootAsAuthGate(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.authGate, (route) => false);
  }

//---------------------------------------------------------//

  ///Go to AuthScreenView
  static void goToProfileScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.profileScreen,
    );
  }
}
