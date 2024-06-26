import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PageNotFound extends StatelessWidget {
  final String errorMessage;
  const PageNotFound({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(10),
              OutlinedButton(
                onPressed: () => context.goNamed(Routes.home.name),
                child: const Text(
                  'Home',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
