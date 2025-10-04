import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minimart/features/products/presentation/controllers/product_list_controller.dart';
import '../data/product_repository.dart';
import '../../cart/presentation/controllers/cart_controller.dart'; // ถ้ามี

class ProductDetailPage extends ConsumerWidget {
  final String id;
  const ProductDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(productRepositoryProvider);
    return FutureBuilder(
      future: repo.getById(id),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final p = snap.data!;
        return Scaffold(
          appBar: AppBar(title: Text(p.title)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(p.mainImageUrl ?? ''),
              ),
              const SizedBox(height: 12),
              Text(
                '${p.price} ฿',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(p.description ?? ''),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // สเต็ปนี้ยังไม่บังคับล็อกอิน: ใส่ตะกร้า local ได้ (ทำจริงในสเต็ปถัดไป)
                  // ref.read(cartControllerProvider.notifier).add(p); // ถ้ามี
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ใส่ตะกร้าแล้ว (ชั่วคราว)')),
                  );
                },
                child: const Text('ใส่ตะกร้า'),
              ),
            ],
          ),
        );
      },
    );
  }
}
