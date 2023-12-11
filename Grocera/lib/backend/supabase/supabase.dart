import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

export 'database/database.dart';

const _kSupabaseUrl = 'https://cqtodunohosotkryasda.supabase.co';
const _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxdG9kdW5vaG9zb3Rrcnlhc2RhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIyMTI2NzYsImV4cCI6MjAxNzc4ODY3Nn0.9-8SS0Mlkzr6qogJ1DB_JHFGiAdjj47ohtUzbWaqrF4';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        anonKey: _kSupabaseAnonKey,
        debug: false,
      );
}
