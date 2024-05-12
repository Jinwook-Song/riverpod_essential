import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/auth/reset_password/reset_password_provider.dart';
import 'package:fb_auth_riverpod/pages/auth/widgets/auth_input.dart';
import 'package:fb_auth_riverpod/pages/widgets/buttons.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(resetPasswordProvider.notifier).sendPasswordResetEmail(
          _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(resetPasswordProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) => errorDialog(context, error as CustomError),
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset email has been sent.'),
            ),
          );
          context.goNamed(Routes.signin.name);
        },
      );
    });

    final resetPasswordProviderState = ref.watch(resetPasswordProvider);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  const FlutterLogo(size: 150),
                  const Gap(20),
                  AuthInput(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 30,
                    ),
                  ),
                  const Gap(20),
                  const Gap(20),
                  CustomFilledButton(
                    onPressed: resetPasswordProviderState.maybeWhen(
                      loading: () => null,
                      orElse: () => _onSubmit,
                    ),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    child: Text(
                      resetPasswordProviderState.maybeWhen(
                        loading: () => 'Loading...',
                        orElse: () => 'Reset Password',
                      ),
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Remember password?'),
                      const Gap(10),
                      CustomTextButton(
                        onPressed: resetPasswordProviderState.maybeWhen(
                          loading: () => null,
                          orElse: () =>
                              () => context.pushNamed(Routes.signin.name),
                        ),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        child: const Text('Sign In'),
                      ),
                    ],
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
