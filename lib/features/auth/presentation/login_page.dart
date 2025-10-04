import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/validators.dart';
import 'controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => Validators.email(v ?? ''),
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => Validators.password(v ?? ''),
              ),
              const SizedBox(height: 12),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          if (!(_formKey.currentState?.validate() ?? false))
                            return;
                          setState(() => _loading = true);
                          _error = null;
                          try {
                            await ref
                                .read(authActionProvider)
                                .login(_email.text.trim(), _password.text);
                            if (mounted) context.go('/products');
                          } catch (e) {
                            setState(() => _error = e.toString());
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/signup'),
                child: const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
