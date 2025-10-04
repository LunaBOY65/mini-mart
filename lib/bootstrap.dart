// ตั้งค่า global (error handler, logger)

import 'package:flutter/material.dart';
import 'package:minimart/core/config/supabase_client.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: init services
  await initSupabase();
  // set error handlers, logger, etc.
}
