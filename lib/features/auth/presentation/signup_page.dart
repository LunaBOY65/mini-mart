import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupDemoPage extends StatefulWidget {
  final String? redirect;
  const SignupDemoPage({super.key, this.redirect});

  @override
  State<SignupDemoPage> createState() => _SignupDemoPageState();
}

class _SignupDemoPageState extends State<SignupDemoPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  Future<void> _signup() async {
    setState(() => _loading = true);
    try {
      final supa = Supabase.instance.client;
      final res = await supa.auth.signUp(
        email: _email.text.trim(),
        password: _pass.text,
      );
      final uid = res.user?.id;
      if (uid != null) {
        await supa.from('profiles').upsert({
          'id': uid,
          'email': _email.text.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
      final target = widget.redirect != null
          ? Uri.decodeComponent(widget.redirect!)
          : '/products';
      if (mounted) context.go(target);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup (Demo)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pass,
              decoration: const InputDecoration(labelText: 'Password (≥6)'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loading ? null : _signup,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Create account'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(
                '/login?redirect=${Uri.encodeComponent(widget.redirect ?? '/products')}',
              ),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
