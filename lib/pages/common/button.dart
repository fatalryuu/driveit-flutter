import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback action;
  final String text;
  final bool disabled;
  final Color color;

  const Button({
    super.key,
    required this.action,
    required this.text,
    this.disabled = false,
    this.color = Colors.pink,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 52.5,
      child: ElevatedButton(
        onPressed: disabled ? null : action,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            disabled ? Colors.grey : color,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: disabled ? Colors.grey[300] : Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}