// ห่อ Supabase Storage (upload/getUrl)

import 'dart:io';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileStorageService {
  final _supabase = Supabase.instance.client;

  /// อัปโหลดรูปโปรไฟล์ไปที่ bucket 'avatars/{uid}/<timestamp>.<ext>'
  /// คืนค่า public URL
  Future<String> uploadAvatar(File file) async {
    final uid = _supabase.auth.currentUser!.id;

    final mime = lookupMimeType(file.path) ?? 'image/jpeg';
    final ext = _extFromMime(mime); // .jpg / .png / .webp
    final path = '$uid/${DateTime.now().millisecondsSinceEpoch}$ext';

    await _supabase.storage
        .from('avatars')
        .upload(path, file, fileOptions: FileOptions(contentType: mime));

    return _supabase.storage.from('avatars').getPublicUrl(path);
  }

  /// ถ้าอยากลบไฟล์เก่า
  Future<void> deleteAvatarByUrl(String publicUrl) async {
    final bucket = _supabase.storage.from('avatars');
    final prefix = bucket.getPublicUrl(''); // ใช้หา prefix ของ public URL
    final path = publicUrl.replaceFirst(prefix, '');
    if (path.isNotEmpty) {
      await bucket.remove([path]);
    }
  }

  String _extFromMime(String mime) {
    if (mime.contains('png')) return '.png';
    if (mime.contains('webp')) return '.webp';
    return '.jpg';
  }
}
