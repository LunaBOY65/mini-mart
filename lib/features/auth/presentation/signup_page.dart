import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/validators.dart';
import 'controllers/auth_controller.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});
  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
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
              TextFormField(
                controller: _confirm,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                ),
                obscureText: true,
                validator: (v) =>
                    v == _password.text ? null : 'Password not match',
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
                                .signup(_email.text.trim(), _password.text);
                            if (mounted) context.go('/products');
                          } catch (e) {
                            setState(() => _error = e.toString());
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Create account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
