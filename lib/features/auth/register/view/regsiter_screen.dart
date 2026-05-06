import 'package:app/features/home/view/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/base_view_model.dart';
import '../../../../core/utils/widgets/app_snckbar.dart';
import '../../login/view/login_screen.dart';
import '../../widgets/auth_text_field.dart';
import '../viewmodel/register_provider.dart';
import '../../widgets/app_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// SUCCESS
      if (vm.state == ViewState.success) {
        AppSnackbar.show(
          context,
          message: "Account created successfully 🎉",
          type: SnackbarType.success,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }

      /// ERROR
      if (vm.state == ViewState.error) {
        AppSnackbar.show(
          context,
          message: vm.errorMessage ?? "Something went wrong",
          type: SnackbarType.error,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                const SizedBox(height: 40),

                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  "Register to continue",
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),

                /// NAME
                AuthTextField(
                  controller: nameController,
                  hint: "Full Name",
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter name" : null,
                ),

                const SizedBox(height: 18),

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

                /// REGISTER BUTTON
                AppButton(
                  text: "Register",
                  loading: vm.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.register(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    }
                  },
                ),

                const SizedBox(height: 25),

                /// LOGIN REDIRECT
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: "Login",
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
