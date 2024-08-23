import 'package:chatapp6/pages/login_pages.dart';
import 'package:flutter/material.dart';

import '../pages/regist.dart';

class LoginOrRegist extends StatefulWidget {
  const LoginOrRegist({super.key});

  @override
  State<LoginOrRegist> createState() => _LoginOrRegistState();
}

class _LoginOrRegistState extends State<LoginOrRegist> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
