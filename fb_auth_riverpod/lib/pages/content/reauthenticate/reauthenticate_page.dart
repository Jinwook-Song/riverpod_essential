import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/auth/widgets/auth_input.dart';
import 'package:fb_auth_riverpod/repositories/auth_repository_provider.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ReauthenticatePage extends ConsumerStatefulWidget {
  const ReauthenticatePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReauthenticatePageState();
}

class _ReauthenticatePageState extends ConsumerState<ReauthenticatePage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;
    setState(() => _submitting = true);

    try {
      final navigagtor = Navigator.of(context);
      await ref.read(authRepositoryProvider).reauthenticateWithCredential(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      setState(() => _submitting = false);
      navigagtor.pop();
    } on CustomError catch (e) {
      if (!mounted) return;
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Reauthenticate'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: [
                  const Text(
                    'This is a security-sensitive operation\nyou must have recently signed-in!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(40),
                  AuthInput(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 30,
                    ),
                  ),
                  const Gap(20),
                  AuthInput(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 30,
                    ),
                  ),
                  const Gap(20),
                  AbsorbPointer(
                    absorbing: _submitting,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child:
                          Text(_submitting ? 'Loading...' : 'Reauthenticate'),
                    ),
                  ),
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
