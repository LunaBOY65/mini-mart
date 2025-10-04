// GoRouter/RouteMap รวมทุก feature route
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/auth/presentation/splash_guard.dart';
import '../../features/products/presentation/products_page.dart';

final router = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (_, __) => const SplashGuard()),
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/signup', builder: (_, __) => const SignupPage()),
    GoRoute(path: '/products', builder: (_, __) => const ProductsPage()),
  ],
);
