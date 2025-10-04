import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavScaffold extends StatelessWidget {
  final Widget child;
  const BottomNavScaffold({super.key, required this.child});

  // กำหนดแท็บหลักกับ path ที่จะไป
  static const _tabs = <({String label, IconData icon, String path})>[
    (label: 'Home', icon: Icons.storefront, path: '/products'),
    // (label: 'Cart', icon: Icons.shopping_cart, path: '/cart'),
    // (label: 'Orders', icon: Icons.receipt_long, path: '/orders'),
    (label: 'Profile', icon: Icons.person, path: '/profile'),
  ];

  int _indexFromLocation(String location) {
    // match แบบง่าย: เริ่มด้วย path ของแท็บไหน ให้ถือว่าอยู่แท็บนั้น
    final i = _tabs.indexWhere((t) => location.startsWith(t.path));
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        // ใช้ Material 3; เปลี่ยนเป็น BottomNavigationBar ก็ได้
        selectedIndex: currentIndex,
        onDestinationSelected: (i) {
          final target = _tabs[i].path;
          if (target != location) context.go(target);
        },
        destinations: [
          for (final t in _tabs)
            NavigationDestination(icon: Icon(t.icon), label: t.label),
        ],
      ),
    );
  }
}
