// อ่านค่า ENV (SUPABASE_URL, SUPABASE_ANON_KEY)

class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static void assertLoaded() {
    assert(
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty,
      'Missing SUPABASE_URL/SUPABASE_ANON_KEY',
    );
  }
}
