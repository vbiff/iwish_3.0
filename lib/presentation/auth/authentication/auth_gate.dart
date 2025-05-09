import 'package:flutter/material.dart';
import 'package:i_wish/presentation/auth/authentication/auth_page.dart';
import 'package:i_wish/presentation/home/tabs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //listen to auth changes
        stream: Supabase.instance.client.auth.onAuthStateChange,

        // Build appropriate screen
        builder: (context, snapshot) {
          // loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          // check if there is valid session
          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session != null) {
            return const TabsScreen();
          } else {
            return const AuthPage();
          }
        });
  }
}
