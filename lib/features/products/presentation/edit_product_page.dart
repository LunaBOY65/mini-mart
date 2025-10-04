import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../products/data/product_repository.dart';
import '../../../core/services/file_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});
  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final title = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();
  File? imageFile;
  bool saving = false;
  String? error;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x != null) setState(() => imageFile = File(x.path));
  }

  Future<void> _save() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final user = Supabase.instance.client.auth.currentUser!;
      String? imageUrl;
      if (imageFile != null) {
        final path = '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await FileStorageService().uploadPublic(
          bucket: 'product-images',
          path: path,
          file: imageFile!,
        );
      }
      final prod = Product(
        title: title.text.trim(),
        price: double.tryParse(price.text.trim()) ?? 0,
        description: desc.text.trim().isEmpty ? null : desc.text.trim(),
        imageUrl: imageUrl,
        ownerId: user.id,
      );
      await ProductRepository().create(prod);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: price,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: desc,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick image'),
                ),
                const SizedBox(width: 12),
                if (imageFile != null) Text(imageFile!.path.split('/').last),
              ],
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: saving ? null : _save,
              child: Text(saving ? 'Saving...' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
