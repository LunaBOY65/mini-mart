import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'controllers/auth_controller.dart';

class SplashGuard extends ConsumerWidget {
  const SplashGuard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    return auth.when(
      data: (user) {
        // มี user -> ไป products, ไม่มี -> login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(user == null ? '/login' : '/products');
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text('Something went wrong'))),
    );
  }
}
