// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'bootstrap.dart';

Future<void> main() async {
  await bootstrap(); // รวม ensureInitialized + Supabase.initialize ไว้ในนี้แล้ว
  runApp(const ProviderScope(child: MiniMartApp()));
}
