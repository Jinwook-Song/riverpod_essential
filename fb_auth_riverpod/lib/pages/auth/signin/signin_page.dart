import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/auth/signin/signin_provider.dart';
import 'package:fb_auth_riverpod/pages/auth/widgets/auth_input.dart';
import 'package:fb_auth_riverpod/pages/widgets/buttons.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(signinProvider.notifier).signin(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signinProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) => errorDialog(context, error as CustomError),
      );
    });

    final signinState = ref.watch(signinProvider);

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
                  CustomFilledButton(
                    onPressed: signinState.maybeWhen(
                      loading: () => null,
                      orElse: () => _onSubmit,
                    ),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    child: Text(
                      signinState.maybeWhen(
                        loading: () => 'Loading...',
                        orElse: () => 'Sign In',
                      ),
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member?'),
                      const Gap(10),
                      CustomTextButton(
                        onPressed: signinState.maybeWhen(
                          loading: () => null,
                          orElse: () =>
                              () => context.pushNamed(Routes.signup.name),
                        ),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                  const Gap(10),
                  CustomTextButton(
                    onPressed: () {
                      signinState.maybeWhen(
                        loading: () => null,
                        orElse: () =>
                            context.goNamed(Routes.resetPassword.name),
                      );
                    },
                    foregroundColor: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    child: const Text('Forgot password?'),
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
