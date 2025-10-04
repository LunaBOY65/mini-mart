//list/create/update/delete + storage รูป

import 'package:supabase_flutter/supabase_flutter.dart';

class Product {
  final int? id;
  final String title;
  final double price;
  final String? description;
  final String? imageUrl;
  final String ownerId;
  Product({
    this.id,
    required this.title,
    required this.price,
    this.description,
    this.imageUrl,
    required this.ownerId,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'] as int?,
    title: j['title'] as String,
    price: double.parse(j['price'].toString()),
    description: j['description'] as String?,
    imageUrl: j['image_url'] as String?,
    ownerId: j['owner_id'] as String,
  );

  Map<String, dynamic> toInsert() => {
    'title': title,
    'price': price,
    'description': description,
    'image_url': imageUrl,
    'owner_id': ownerId,
  };
}

class ProductRepository {
  final supa = Supabase.instance.client;

  Future<List<Product>> list() async {
    final res = await supa
        .from('products')
        .select('*')
        .order('created_at', ascending: false);
    return (res as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> create(Product p) async {
    final row = await supa
        .from('products')
        .insert(p.toInsert())
        .select('id')
        .single();
    return row['id'] as int;
  }
}
