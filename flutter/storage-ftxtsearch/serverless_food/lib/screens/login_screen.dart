import 'package:flutter/material.dart';
import 'package:serverless_food/services/auth_service.dart';
import 'package:serverless_food/utils/constants.dart';
import 'package:serverless_food/widget/rounded_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLoginLabel(),
              const SizedBox(
                height: 32.0,
              ),
              _buildEmailTextField(context),
              const SizedBox(
                height: 16.0,
              ),
              _buildPasswordTextField(context),
              const SizedBox(
                height: 16.0,
              ),
              _buildLoginButton(context),
              _buildSignUpButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLabel() {
    return const Text(
      'Log in',
      style: TextStyle(fontSize: 34),
    );
  }

  Widget _buildEmailTextField(BuildContext context) {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return RoundedButton(
      text: 'Log in',
      onPressedAction: () => _logIn(context),
      showLoader: isLoading,
    );
  }

  _logIn(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final session = await AuthService.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (session != null) {
        Navigator.of(context).pushNamed('/home');
      } else {
        context.showErrorSnackBar(message: 'Something went wrong');
      }
    } on GotrueError catch (e) {
      context.showErrorSnackBar(message: e.message);
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildSignUpButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pushReplacementNamed('/register'),
      child: const Text(
        "Don't have an account? Sign up",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.black,
        ),
      ),
    );
  }
}
