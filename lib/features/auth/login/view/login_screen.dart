import 'package:app/features/auth/register/view/regsiter_screen.dart';
import 'package:app/features/home/view/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/base_view_model.dart';
import '../../../../core/utils/widgets/app_snckbar.dart';
import '../../widgets/auth_text_field.dart';
import '../viewmodel/login_model.dart';

import '../../widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      /// SUCCESS
      if (vm.state == ViewState.success) {
        AppSnackbar.show(
          context,
          message: "Login successful 🎉",
          type: SnackbarType.success,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Home()),
        );
      }

      /// ERROR
      if (vm.state == ViewState.error) {
        AppSnackbar.show(
          context,
          message: vm.errorMessage ?? "Login failed",
          type: SnackbarType.error,
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 40),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Login to continue",
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),

                /// EMAIL
                AuthTextField(
                  controller: emailController,
                  hint: "Email",
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Enter email";
                    }
                    if (!v.contains("@")) {
                      return "Invalid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// PASSWORD
                AuthTextField(
                  controller: passwordController,
                  hint: "Password",
                  obscure: true,
                  validator: (v) => v != null && v.length >= 6
                      ? null
                      : "Minimum 6 characters",
                ),

                const SizedBox(height: 30),

                /// LOGIN BUTTON
                AppButton(
                  text: "Login",
                  loading: vm.isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      vm.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),

                        // ✅ Success and error handling RIGHT HERE — easy to read
                        onSuccess: () {
                          AppSnackbar.show(
                            context,
                            message: "Login successful 🎉",
                            type: SnackbarType.success,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => Home()),
                          );
                        },

                        onError: (message) {
                          AppSnackbar.show(
                            context,
                            message: message,
                            type: SnackbarType.error,
                          );
                        },
                      );

                    }
                  },
                ),

                const SizedBox(height: 25),

                /// REGISTER REDIRECT
                Center(
                  child: GestureDetector(
                    onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                    },
                    child:  RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}