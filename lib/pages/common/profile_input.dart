import 'package:flutter/material.dart';

class ProfileInput extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isEditing;

  const ProfileInput({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 14.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              placeholder,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                          color: isEditing ? Colors.white : Colors.grey,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: TextField(
                        controller: controller,
                        enabled: isEditing,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: isEditing ? "Enter..." : "No data",
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.only(bottom: 5.0),
                        ),
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                        autocorrect: false,
                      ),
                    ),
                  )))
        ]));
  }
}
