class EnvConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://msxypcehcczfjteqmgdu.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zeHlwY2VoY2N6Zmp0ZXFtZ2R1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0MTAyNzUsImV4cCI6MjA1Nzk4NjI3NX0.dqQbBD_0xE1xT_STAu9TBdUCE8eQI3I_xX0t2ockykU',
  );

  static bool get isProduction =>
      const bool.fromEnvironment('PRODUCTION', defaultValue: false);
  static bool get isDevelopment => !isProduction;
}
