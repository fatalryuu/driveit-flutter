import 'package:driveit/pages/common/error_label.dart';
import 'package:driveit/services/auth_service.dart';
import 'package:driveit/pages/common/button.dart';
import 'package:driveit/pages/common/input.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback showSignUpPage;

  const SignInPage({super.key, required this.showSignUpPage});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _formError = "";
  bool _isLoading = false;

  bool isButtonDisabled() {
    return _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _isLoading;
  }

  Future<void> signIn() async {
    if (_passwordController.text.length < 8) {
      setState(() {
        _formError = "Password should be at least 8 characters long";
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _formError = "";
      });

      await AuthService.signIn(_emailController.text, _passwordController.text);
    } catch (error) {
      setState(() {
        if (error.toString().contains("invalid-credential")) {
          _formError = "Invalid email or password";
        } else if (error.toString().contains("invalid-email")) {
          _formError = "The email address is badly formatted";
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
                  'Welcome back',
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

                if (_formError.isNotEmpty) ErrorLabel(text: _formError),

                SizedBox(height: _formError.isEmpty ? 28.0 : 10.0),

                Button(
                    action: signIn,
                    text: "Sign In",
                    disabled: isButtonDisabled()),

                const SizedBox(height: 12.0),

                GestureDetector(
                  onTap: widget.showSignUpPage,
                  child: const Text(
                    'Don\'t have an account?',
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
