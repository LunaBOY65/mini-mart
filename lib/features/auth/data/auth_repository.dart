import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/db_tables.dart';
import '../../../core/config/supabase_client.dart';

class AuthRepository {
  final SupabaseClient _sb;
  AuthRepository([SupabaseClient? client]) : _sb = client ?? Supa.client;

  Stream<AuthChangeEvent> onAuthEvent() =>
      _sb.auth.onAuthStateChange.map((s) => s.event);

  // สตรีม AuthState (event + session)
  Stream<AuthState> onAuthState() => _sb.auth.onAuthStateChange;

  // สตรีมเฉพาะ User? (ใช้งานกับ UI สะดวก)
  Stream<User?> onAuthUser() =>
      _sb.auth.onAuthStateChange.map((s) => s.session?.user);
  Session? get currentSession => _sb.auth.currentSession;
  User? get currentUser => _sb.auth.currentUser;

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final res = await _sb.auth.signInWithPassword(
      email: email,
      password: password,
    );
    await _ensureProfile(res.user);
    return res;
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    // NOTE: Email confirmations ถูกปิดใน Dashboard สำหรับ MVP
    final res = await _sb.auth.signUp(email: email, password: password);

    // กรณีบางครั้งตั้งค่าเพิ่งเปลี่ยนและยังไม่ได้ session กลับมา → fallback
    if (res.session == null) {
      final loginRes = await _sb.auth.signInWithPassword(
        email: email,
        password: password,
      );
      await _ensureProfile(loginRes.user);
      return loginRes;
    }

    await _ensureProfile(res.user); // upsert โปรไฟล์แบบ idempotent
    return res;
  }

  Future<void> signOut() => _sb.auth.signOut();

  /// upsert โปรไฟล์แบบ idempotent (ฝึกใช้ RLS: insert own profile)
  Future<void> _ensureProfile(User? user) async {
    if (user == null) return;
    await _sb.from(DbTables.profiles).upsert({
      'id': user.id,
      'email': user.email,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'id'); // ถ้ามีอยู่แล้วจะอัปเดต updated_at
  }
}
