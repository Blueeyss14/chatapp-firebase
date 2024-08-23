import 'package:chatapp6/auth/auth_services.dart';
import 'package:chatapp6/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_ button.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthServices>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(emailController.text, passwordController.text
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
                MyButton(
                    onTap: signIn,
                    text: "Sign In"
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member? "),
                    GestureDetector(
                        onTap: widget.onTap,
                        child: Text("Register Now", style: TextStyle(fontWeight: FontWeight.bold),)),
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
