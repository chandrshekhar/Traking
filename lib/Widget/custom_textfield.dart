import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.controller,
      this.labelText,
      this.onChanged,
      this.suffixIcon});

  final TextEditingController controller;
  final String? labelText;
  void Function(String)? onChanged;
  Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            border: const OutlineInputBorder(),
            hintText: labelText),
      ),
    );
  }
}
