import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/product.dart'; // ← ใช้โมเดลเดียวจาก domain

class ProductRepository {
  final _db = Supabase.instance.client;

  Future<List<Product>> listAll() async {
    final rows = await _db
        .from('products')
        // alias: ชื่อที่โค้ดต้องการ : ชื่อคอลัมน์จริงใน DB (image_url)
        .select(
          'id,title,price,owner_id,thumbnail_url:image_url,main_image_url:image_url',
        )
        .order('created_at', ascending: false); // ← เหลืออันเดียวพอ
    return rows.map<Product>((r) => Product.fromMap(r)).toList();
  }

  Future<Product?> getById(String id) async {
    final row = await _db
        .from('products')
        .select(
          'id,title,description,price,owner_id,thumbnail_url:image_url,main_image_url:image_url',
        )
        .eq('id', id)
        .maybeSingle();
    return row == null ? null : Product.fromMap(row);
  }
}
