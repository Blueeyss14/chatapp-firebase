import 'package:chatapp6/auth/auth_services.dart';
import 'package:chatapp6/components/my_%20button.dart';
import 'package:chatapp6/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password do not match!")
      ));
      return;
    }

    final authService = Provider.of<AuthServices>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),
        ),
          );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.message, size: 80,),
                const Text("Welcome"),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: emailController,
                  hintText: 'email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: passwordController,
                  hintText: 'password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: 'confirmation password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyButton(
                    onTap: signUp,
                    text: "Sign In"
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                        onTap: widget.onTap,
                        child: Text("Login Now", style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
