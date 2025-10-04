// lib/features/auth/data/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ตรวจอีเมลแบบเบาๆ พอสำหรับฟอร์มเดโม
  bool _isValidEmail(String email) {
    final e = email.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e);
  }

  Future<void> signIn({required String email, required String password}) async {
    final e = email.trim().toLowerCase();
    if (!_isValidEmail(e)) {
      throw 'อีเมลไม่ถูกต้อง';
    }
    await _supabase.auth.signInWithPassword(email: e, password: password);
  }

  Future<void> signUp({required String email, required String password}) async {
    final e = email.trim().toLowerCase();

    final res = await _supabase.auth.signUp(email: e, password: password);

    // เดโม: ถ้าปิด email confirmations แล้ว ส่วนใหญ่ res.session จะมีมาทันที
    // แต่ถ้าไม่มี ให้ sign-in ต่อทันที
    if (res.session == null) {
      await _supabase.auth.signInWithPassword(email: e, password: password);
    }

    final uid = _supabase.auth.currentUser?.id ?? res.user?.id;
    if (uid != null) {
      await _supabase.from('profiles').upsert({
        'id': uid,
        'email': e,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> signOut() async => _supabase.auth.signOut();
}
