import 'dart:async';

import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/repositories/auth_repository_provider.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sendEmailVerification();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    // context에 대한 처리
    final goRouter = GoRouter.of(context);
    void errorDialogRef(CustomError e) {
      errorDialog(context, e);
    }

    try {
      await ref.read(authRepositoryProvider).reloadUser();

      if (fbAuthService.currentUser!.emailVerified == true) {
        _timer?.cancel();
        goRouter.goNamed(Routes.home.name);
      }
    } on CustomError catch (e) {
      if (!mounted) return;
      errorDialogRef(e);
    }
  }

  Future<void> _sendEmailVerification() async {
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
    } on CustomError catch (e) {
      if (!mounted) return;
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Verification email has been sent to'),
                  Text('${fbAuthService.currentUser?.email}'),
                  const Text('If you cannot find verification email,'),
                  RichText(
                    text: TextSpan(
                      text: 'Please check ',
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 18),
                      children: const [
                        TextSpan(
                          text: 'SPAM',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' folder.'),
                      ],
                    ),
                  ),
                  const Text('or, your email is correct.'),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  await ref.read(authRepositoryProvider).signout();
                  _timer?.cancel();
                } on CustomError catch (e) {
                  if (!context.mounted) return;
                  errorDialog(context, e);
                }
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
