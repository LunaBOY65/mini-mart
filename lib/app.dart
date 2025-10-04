// MaterialApp + ProviderScope + Router

import 'package:flutter/material.dart';
import 'core/config/router.dart'; // ต้องมีตัวแปร router หรือ appRouter

class MiniMartApp extends StatelessWidget {
  const MiniMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini Mart',
      routerConfig:
          appRouter, // ถ้าไฟล์ router ของคุณใช้ชื่อ appRouter ให้เปลี่ยนตรงนี้
      debugShowCheckedModeBanner: false,
    );
  }
}
