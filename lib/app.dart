// MaterialApp + ProviderScope + Router

import 'package:flutter/material.dart';
import 'core/config/router.dart'; // ✅ ใช้ GoRouter ที่ประกาศไว้

class MiniMartApp extends StatelessWidget {
  const MiniMartApp({super.key});
  @override
  Widget build(BuildContext context) {
    // เปลี่ยนมาใช้ GoRouter แทน routes map
    return MaterialApp.router(
      title: 'Mini Mart',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
