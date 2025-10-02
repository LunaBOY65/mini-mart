import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';

class Supa {
  static SupabaseClient get client => Supabase.instance.client;
}

Future<void> initSupabase() async {
  Env.assertLoaded();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
}
