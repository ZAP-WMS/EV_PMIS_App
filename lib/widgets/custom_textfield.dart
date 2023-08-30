import 'dart:ui';

import 'package:flutter/material.dart';

import '../style.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  String labeltext;
  // final String? validator;
  final String? validatortext;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  CustomTextField(
      {super.key,
      required this.controller,
      required this.labeltext,
      // this.validator,
      required this.validatortext,
      required this.keyboardType,
      required this.textInputAction});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          labelText: widget.labeltext,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey))),
      validator: (value) {
        if (value!.isEmpty) {
          return widget.validatortext;
        }
        return null;
      },
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
    );
  }
}
