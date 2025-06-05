import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_wish/presentation/auth/authentication/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
        textTheme: GoogleFonts.aBeeZeeTextTheme(),
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: const AuthGate(),
    );
  }
}
