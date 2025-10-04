// ตั้งค่า global (error handler, logger)

import 'package:flutter/material.dart';
import 'core/config/supabase_client.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase(); // ภายในไปเรียก Supabase.initialize แล้ว
  // TODO: set error handlers / logger (ถ้ามี)
}
