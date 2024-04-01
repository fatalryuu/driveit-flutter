import 'package:flutter/material.dart';

class ErrorLabel extends StatelessWidget {
  final String text;

  const ErrorLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}
