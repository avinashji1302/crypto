import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final String? Function(String?) validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.validator,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        // fillColor: Colors.grey.shade900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}