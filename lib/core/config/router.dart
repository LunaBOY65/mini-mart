import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/products/presentation/products_page.dart';
import '../../features/products/presentation/product_detail_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/checkout/presentation/checkout_page.dart';
import '../../features/orders/presentation/orders_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/edit_profile_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';

import '../widgets/bottom_nav_scaffold.dart'; // << นี่คือสเกฟโฟลด์ใหม่

String? _requireAuth(BuildContext context, GoRouterState state) {
  final session = Supabase.instance.client.auth.currentSession;
  if (session == null) {
    final target = Uri.encodeComponent(state.uri.toString());
    return '/login?redirect=$target';
  }
  return null;
}

final appRouter = GoRouter(
  initialLocation: '/products',
  routes: [
    // -------- auth pages (อยู่นอก shell) --------
    GoRoute(
      path: '/login',
      redirect: (context, state) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          // ถ้าล็อกอินอยู่แล้ว ไม่ต้องเห็นหน้า login
          final target = state.uri.queryParameters['redirect'];
          return target != null ? Uri.decodeComponent(target) : '/products';
        }
        return null;
      },
      builder: (c, s) =>
          LoginDemoPage(redirect: s.uri.queryParameters['redirect']),
    ),

    GoRoute(
      path: '/signup',
      redirect: (context, state) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          final target = state.uri.queryParameters['redirect'];
          return target != null ? Uri.decodeComponent(target) : '/products';
        }
        return null;
      },
      builder: (c, s) =>
          SignupDemoPage(redirect: s.uri.queryParameters['redirect']),
    ),

    // -------- ShellRoute ครอบแท็บหลัก + bottom bar --------
    ShellRoute(
      builder: (context, state, child) => BottomNavScaffold(child: child),
      routes: [
        // Home (public)
        GoRoute(
          path: '/products',
          builder: (c, s) => const ProductsPage(),
          routes: [
            // ถ้าหน้ารายละเอียดต้องอยู่ “ใต้” Home ก็ใส่เป็น child แบบนี้
            GoRoute(
              path: 'detail/:id', // => /products/detail/123
              builder: (c, s) => ProductDetailPage(id: s.pathParameters['id']!),
            ),
          ],
        ),

        // Cart (protected)
        GoRoute(
          path: '/cart',
          redirect: _requireAuth,
          builder: (c, s) => const CartPage(),
        ),

        // Orders (protected)
        GoRoute(
          path: '/orders',
          redirect: _requireAuth,
          builder: (c, s) => const OrdersPage(),
        ),

        // Profile (protected)
        GoRoute(
          path: '/profile',
          redirect: _requireAuth,
          builder: (c, s) => const ProfilePage(),
          routes: [
            GoRoute(
              path: 'edit', // => /profile/edit
              redirect: _requireAuth,
              builder: (c, s) => const EditProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // -------- หน้าที่อยู่นอก bottom bar --------
    GoRoute(
      path:
          '/product/:id', // ทางเลือก: รายละเอียดอยู่นอก shell (จะไม่เห็น bottom bar)
      builder: (c, s) => ProductDetailPage(id: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/checkout',
      redirect: _requireAuth,
      builder: (c, s) => const CheckoutPage(),
    ),
  ],
);
