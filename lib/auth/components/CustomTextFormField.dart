import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  TextEditingController controller;
  bool obscureText;
  String? Function(String?)? validate;

  CustomTextFormField({
    required this.label,
    required this.controller,
    required this.validate,
    this.keyboardType = TextInputType.text,
    this.obscureText = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                width: 3,
                color: Theme.of(context).primaryColor
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                width: 3,
                color: Theme.of(context).primaryColor
            ),
          ),
        ),
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        validator: validate,
      ),
    );
  }
}
