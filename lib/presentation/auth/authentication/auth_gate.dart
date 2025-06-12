import 'package:flutter/material.dart';
import 'package:i_wish/presentation/auth/authentication/auth_page.dart';
import 'package:i_wish/presentation/home/tabs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    print('[AUTH GATE] AuthGate initialized');

    // Listen for auth state changes and force rebuild
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      print('[AUTH GATE] Auth state change detected: ${data.event}');
      if (mounted) {
        setState(() {
          // Force rebuild when auth state changes
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('[AUTH GATE] Building AuthGate');

    // Check current session first
    final currentSession = Supabase.instance.client.auth.currentSession;
    print('[AUTH GATE] Current session: ${currentSession?.user.email}');

    return StreamBuilder(
        //listen to auth changes
        stream: Supabase.instance.client.auth.onAuthStateChange,

        // Build appropriate screen
        builder: (context, snapshot) {
          print('[AUTH GATE] Stream builder called');
          print('  - Connection state: ${snapshot.connectionState}');
          print('  - Has data: ${snapshot.hasData}');

          if (snapshot.hasData) {
            print('  - Auth event: ${snapshot.data!.event}');
            print('  - Session user: ${snapshot.data!.session?.user.email}');
          }

          // loading...
          if (snapshot.connectionState == ConnectionState.waiting &&
              currentSession == null) {
            print('[AUTH GATE] Showing loading state');
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }

          // check if there is valid session
          final session =
              snapshot.hasData ? snapshot.data!.session : currentSession;

          if (session != null) {
            print('[AUTH GATE] Session found, showing TabsScreen');
            print('  - User: ${session.user.email}');
            return const TabsScreen();
          } else {
            print('[AUTH GATE] No session, showing AuthPage');
            return const AuthPage();
          }
        });
  }
}
