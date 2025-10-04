//โมเดลสินค้าพร้อม value object

// lib/features/products/domain/product.dart
/// โมเดลสินค้าแบบบางเบา ใช้ได้กับสคีมานี้:
/// products(id BIGINT, owner_id UUID, title TEXT, price NUMERIC,
///          description TEXT, image_url TEXT)
///
/// หมายเหตุ: ใน repository เรา select โดยใช้นามแฝง (alias)
///   thumbnail_url:image_url, main_image_url:image_url
/// เพื่อให้ field ด้านล่างนี้รับค่าได้ทันที
class Product {
  final String id; // ใช้ String กันปัญหา BIGINT บนเว็บ
  final String ownerId;
  final String title;
  final double price;
  final String? description;
  final String? thumbnailUrl; // มาจาก image_url (alias)
  final String? mainImageUrl; // มาจาก image_url (alias)

  const Product({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.price,
    this.description,
    this.thumbnailUrl,
    this.mainImageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> m) {
    double _toDouble(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse(v?.toString() ?? '') ?? 0.0;
    }

    String? _pickImage(Map<String, dynamic> x) {
      // รับทั้งสองชื่อ (เรา alias มาให้แล้ว)
      final a = x['main_image_url']?.toString();
      final b = x['thumbnail_url']?.toString();
      // ถ้ามีแค่ค่าเดียวก็ใช้ค่านั้น
      if (a != null && a.isNotEmpty) return a;
      if (b != null && b.isNotEmpty) return b;
      // เผื่อคุณยัง select ตรง ๆ เป็น image_url
      final c = x['image_url']?.toString();
      return (c != null && c.isNotEmpty) ? c : null;
    }

    final img = _pickImage(m);

    return Product(
      id: m['id'].toString(),
      ownerId: m['owner_id']?.toString() ?? '',
      title: m['title']?.toString() ?? '',
      price: _toDouble(m['price']),
      description: m['description']?.toString(),
      thumbnailUrl: img,
      mainImageUrl: img,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'owner_id': ownerId,
    'title': title,
    'price': price,
    'description': description,
    // เวลาเขียนกลับ DB คุณอาจต้อง map ไปที่ image_url เอง
    'thumbnail_url': thumbnailUrl,
    'main_image_url': mainImageUrl,
  };

  Product copyWith({
    String? id,
    String? ownerId,
    String? title,
    double? price,
    String? description,
    String? thumbnailUrl,
    String? mainImageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
    );
  }
}
