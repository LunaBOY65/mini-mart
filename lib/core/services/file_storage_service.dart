// ห่อ Supabase Storage (upload/getUrl)

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileStorageService {
  final supa = Supabase.instance.client;

  Future<String> uploadPublic({
    required String bucket,
    required String path,
    required File file,
  }) async {
    await supa.storage
        .from(bucket)
        .upload(path, file, fileOptions: const FileOptions(upsert: true));
    return supa.storage.from(bucket).getPublicUrl(path);
  }
}
