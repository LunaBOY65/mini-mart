import 'package:flutter_riverpod/flutter_riverpod.dart';
// ลบบรรทัดนี้ทิ้ง: import 'package:minimart/features/products/data/product_dto.dart';
import '../../data/product_repository.dart';
import '../../domain/product.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

final productListProvider = FutureProvider<List<Product>>((ref) async {
  return ref.read(productRepositoryProvider).listAll();
});
