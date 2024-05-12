import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.textInputType,
    required this.prefixIcon,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? hintText;
  final TextInputType? textInputType;
  final Icon prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return '$labelText is required';
        }
        switch (labelText) {
          case 'Name':
            if (value.trim().length < 2 || value.trim().length > 12) {
              return '$labelText must be between 2 and 12 characters long.';
            }
            break;
          case 'Email':
            if (!isEmail(value.trim())) {
              return 'Enter a valid email';
            }
            break;
          case 'Password':
            if (value.trim().length < 6) {
              return 'Password must be at least 6 characters.';
            }
            break;
        }
        return null;
      },
    );
  }
}

class ConfirmFormField extends StatelessWidget {
  const ConfirmFormField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: labelText,
        prefixIcon: const Icon(
          Icons.lock,
          size: 30,
        ),
      ),
      validator: (value) {
        if (value != controller.text) {
          return 'Password not matched';
        }
        return null;
      },
    );
  }
}
