import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

void main() async {
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zeHlwY2VoY2N6Zmp0ZXFtZ2R1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0MTAyNzUsImV4cCI6MjA1Nzk4NjI3NX0.dqQbBD_0xE1xT_STAu9TBdUCE8eQI3I_xX0t2ockykU',
    url: 'https://msxypcehcczfjteqmgdu.supabase.co',
  );
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}
