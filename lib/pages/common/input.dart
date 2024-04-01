import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isSecure;
  final Function(String) onChanged;

  const Input({
    super.key,
    required this.controller,
    required this.placeholder,
    this.isSecure = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 2.5, bottom: 2.5),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.only(bottom: 5.0),
              ),
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
              obscureText: isSecure,
              autocorrect: false,
            ),
          ),
        )
      )
    );
  }
}