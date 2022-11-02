import 'package:flutter/material.dart';
import 'package:serverless_food/services/auth_service.dart';
import 'package:serverless_food/services/user_db_service.dart';
import 'package:serverless_food/utils/constants.dart';
import 'package:serverless_food/widget/rounded_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

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
              _buildNameTextField(context),
              const SizedBox(
                height: 16.0,
              ),
              _buildEmailTextField(context),
              const SizedBox(
                height: 16.0,
              ),
              _buildPasswordTextField(context),
              const SizedBox(
                height: 16.0,
              ),
              _buildSignUpButton(context),
              _buildLoginButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLabel() {
    return const Text(
      'Sign up',
      style: TextStyle(fontSize: 34),
    );
  }

  Widget _buildNameTextField(BuildContext context) {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'User name',
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

  Widget _buildSignUpButton(BuildContext context) {
    return RoundedButton(
      text: 'Sign up',
      onPressedAction: () => _signUp(context),
      showLoader: isLoading,
    );
  }

  _signUp(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await AuthService.signUpWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (user != null) {
        /// Add to data base
        final userFromDb = await UserDbService.addUser(
          id: user.id,
          username: _nameController.text,
          email: _emailController.text,
        );
        if (userFromDb == null) {
          context.showErrorSnackBar(message: 'Something went wrong');
        } else {
          Navigator.of(context).pushNamed('/home');
        }
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

  Widget _buildLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
      child: const Text(
        "Do you already have an account? Log in",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.black,
        ),
      ),
    );
  }
}
