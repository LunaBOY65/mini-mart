// email, password, price ฯลฯ

class Validators {
  static String? email(String value) {
    if (value.trim().isEmpty) return 'กรุณากรอกอีเมล';
    // regex เบสิคพอสำหรับฟอร์มทั่วไป
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim());
    return ok ? null : 'อีเมลไม่ถูกต้อง';
  }

  static String? password(String value) {
    if (value.isEmpty) return 'กรุณากรอกรหัสผ่าน';
    if (value.length < 6) return 'รหัสผ่านอย่างน้อย 6 ตัวอักษร';
    return null;
  }
}
