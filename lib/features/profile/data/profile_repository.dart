//อ่าน/อัปเดตโปรไฟล์ใน table profiles

import 'package:supabase_flutter/supabase_flutter.dart';

final supa = Supabase.instance.client;

class ProfileRepository {
  Future<void> ensureProfile({
    required String uid,
    required String email,
  }) async {
    await supa.from('profiles').upsert({
      'id': uid,
      'email': email,
      'name': email.split('@').first,
    });
  }
}
