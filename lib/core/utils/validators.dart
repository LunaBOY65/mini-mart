// email, password, price ฯลฯ

class Validators {
  /// คืนข้อความ error ถ้าไม่ผ่าน, คืน null ถ้าผ่าน (รูปแบบเดียวกับ TextFormField.validator)
  static String? email(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'กรุณากรอกอีเมล';
    // เบสิคพอสำหรับเดโม
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
    return ok ? null : 'อีเมลไม่ถูกต้อง';
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'กรุณากรอกรหัสผ่าน';
    if (v.length < 6) return 'รหัสผ่านอย่างน้อย 6 ตัวอักษร';
    return null;
  }

  /// ใช้ก่อนส่งไปที่ Auth: ตัดช่องว่าง + แปลงเป็นตัวพิมพ์เล็ก
  static String normalizeEmail(String value) => value.trim().toLowerCase();
}
