import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/auth/widgets/auth_input.dart';
import 'package:fb_auth_riverpod/pages/content/change_password/change_password_provider.dart';
import 'package:fb_auth_riverpod/pages/content/reauthenticate/reauthenticate_page.dart';
import 'package:fb_auth_riverpod/pages/widgets/buttons.dart';
import 'package:fb_auth_riverpod/repositories/auth_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(changePasswordProvider.notifier).changePassword(
          _passwordController.text.trim(),
        );
  }

  Future<void> _processSuccessCase() async {
    try {
      await ref.read(authRepositoryProvider).signout();
    } on CustomError catch (e) {
      if (!mounted) return;
      errorDialog(context, e);
    }
  }

  Future<void> _processRequireRecentLogin() async {
    final scaffoldMessager = ScaffoldMessenger.of(context);
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const ReauthenticatePage();
        },
      ),
    );

    if (result == 'success') {
      scaffoldMessager.showSnackBar(
        const SnackBar(content: Text('Successfully reauthenticated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(changePasswordProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) {
          final error = e as CustomError;
          if (error.code == 'requires-recent-login') {
            _processRequireRecentLogin();
          } else {
            errorDialog(context, error);
          }
        },
        data: (data) {
          _processSuccessCase();
        },
      );
    });

    final changePasswordState = ref.watch(changePasswordProvider);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
        ),
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'If you change password,',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'you will be ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: 'signed out!',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const Gap(40),
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
                  ConfirmFormField(
                    controller: _passwordController,
                    labelText: 'Confirm Password',
                  ),
                  const Gap(20),
                  CustomFilledButton(
                    onPressed: changePasswordState.maybeWhen(
                      loading: () => null,
                      orElse: () => _onSubmit,
                    ),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    child: Text(
                      changePasswordState.maybeWhen(
                        loading: () => 'Loading...',
                        orElse: () => 'Change Password',
                      ),
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already a member?'),
                      const Gap(10),
                      CustomTextButton(
                        onPressed: changePasswordState.maybeWhen(
                          loading: () => null,
                          orElse: () => () => context.pop(),
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
