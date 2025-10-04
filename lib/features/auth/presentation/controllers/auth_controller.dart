//Riverpod/Bloc จัด state auth

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateProvider = StreamProvider<User?>((ref) async* {
  final repo = ref.watch(authRepositoryProvider);
  // ยิงค่าปัจจุบันก่อน เพื่อให้หน้า Splash/Guard ตัดสินใจได้ทันที
  yield repo.currentUser;
  // แล้วตามด้วยการเปลี่ยนแปลงแบบสดจากสตรีม User?
  await for (final u in repo.onAuthUser()) {
    yield u;
  }
});

final authActionProvider = Provider((ref) => _AuthAction(ref));

class _AuthAction {
  _AuthAction(this.ref);
  final Ref ref;
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> login(String email, String password) =>
      _repo.signInWithPassword(email: email, password: password);
  Future<void> signup(String email, String password) =>
      _repo.signUp(email: email, password: password);
  Future<void> logout() => _repo.signOut();
}
