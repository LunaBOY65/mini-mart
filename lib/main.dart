import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // เช็คว่าอ่านค่าได้จริง (log แค่ prefix ของ key)
  // ignore: avoid_print
  print(
    'ENV -> URL="${Env.supabaseUrl}" KEY="${Env.supabaseAnonKey.isNotEmpty ? Env.supabaseAnonKey.substring(0, 8) : '(empty)'}..."',
  );

  assert(
    Env.supabaseUrl.startsWith('https://') &&
        Env.supabaseUrl.contains('.supabase.co'),
    'SUPABASE_URL invalid: ${Env.supabaseUrl}',
  );
  assert(Env.supabaseAnonKey.isNotEmpty, 'SUPABASE_ANON_KEY missing');

  await Supabase.initialize(
    url: Env.supabaseUrl.trim(),
    anonKey: Env.supabaseAnonKey.trim(),
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  );
  runApp(const ProviderScope(child: MiniMartApp()));
}
