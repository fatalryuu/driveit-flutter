import 'package:driveit/pages/common/button.dart';
import 'package:driveit/pages/common/error_label.dart';
import 'package:driveit/pages/common/input.dart';
import 'package:driveit/services/auth_service.dart';
import 'package:driveit/services/users_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showSignInPage;

  const SignUpPage({super.key, required this.showSignInPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  String _formError = "";
  bool _isLoading = false;

  bool isButtonDisabled() {
    return _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _repeatPasswordController.text.isEmpty ||
        _isLoading;
  }

  Future<void> signUp() async {
    if (_passwordController.text.length < 8 ||
        _repeatPasswordController.text.length < 8) {
      setState(() {
        _formError = "Password should be at least 8 characters long";
      });
      return;
    }

    if (_passwordController.text != _repeatPasswordController.text) {
      setState(() {
        _formError = "Passwords should match";
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _formError = "";
      });

      final user = await AuthService.signUp(_emailController.text, _passwordController.text);
      await UsersService.createUser(user);
    } catch (error) {
      setState(() {
        if (error.toString().contains("email-already-in-use")) {
          _formError = "This email address is already taken";
        } else {
          _formError = error.toString();
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create a new account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16.0),

                const Text(
                  'Please, enter your credentials',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24.0),

                Input(
                  placeholder: "Email",
                  isSecure: false,
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 18.0),

                Input(
                  placeholder: "Password",
                  isSecure: true,
                  controller: _passwordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 18.0),

                Input(
                  placeholder: "Repeat password",
                  isSecure: true,
                  controller: _repeatPasswordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                if (_formError.isNotEmpty) ErrorLabel(text: _formError),

                SizedBox(height: _formError.isEmpty ? 28.0 : 10.0),

                Button(
                    action: signUp,
                    text: "Create an account",
                    disabled: isButtonDisabled()),

                const SizedBox(height: 12.0),

                GestureDetector(
                  onTap: widget.showSignInPage,
                  child: const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
