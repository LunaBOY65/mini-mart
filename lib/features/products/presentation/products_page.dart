//grid/list สินค้า

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimart/features/auth/presentation/controllers/auth_controller.dart';
import '../../products/data/product_repository.dart';
import 'edit_product_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final repo = ProductRepository();
  List<Product> items = [];
  bool loading = true;

  Future<void> _load() async {
    setState(() => loading = true);
    items = await repo.list();
    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          //ใช้ AuthAction (Riverpod) + GoRouter logout
          Consumer(
            builder: (_, ref, __) => IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authActionProvider).logout();
                if (!context.mounted) return;
                context.go(
                  '/login',
                ); // หรือ context.go('/') ให้ SplashGuard redirect
              },
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(child: Text('No products yet'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final p = items[i];
                return ListTile(
                  leading: p.imageUrl != null
                      ? Image.network(
                          p.imageUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_outlined),
                  title: Text(p.title),
                  subtitle: Text('${p.price.toStringAsFixed(2)}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProductPage()),
          );
          if (created == true) _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
