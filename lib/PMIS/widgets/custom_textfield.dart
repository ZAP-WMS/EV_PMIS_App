import 'package:flutter/material.dart';
import '../../style.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  String? role;
  bool isObscure;
  String labeltext;
  bool isSuffixIcon;
  bool isProjectManager;
  bool isFieldEditable;
  final String? Function(String?)? validatortext;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
    CustomTextField(
      {super.key,
      required this.controller,
      required this.labeltext,
      this.isSuffixIcon = false,
      this.validatortext,
      required this.keyboardType,
      required this.textInputAction,
      this.role,
      this.isProjectManager = true,
      this.isObscure = false,
      this.isFieldEditable = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.isFieldEditable
          ? widget.isProjectManager
              ? false
              : true
          : false,
      controller: widget.controller,
      onChanged: (value) => widget.labeltext,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        labelText: widget.labeltext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
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
            borderSide: const BorderSide(color: Colors.grey)),
        suffixIcon: widget.isSuffixIcon
            ? InkWell(
                onTap: _togglePasswordView,
                child: _isHidden
                    ? const Icon(Icons.visibility_off)
                    : const Icon(
                        Icons.visibility,
                      ))
            : const Text(
                '',
              ),
      ),
      validator: widget.validatortext,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isSuffixIcon ? _isHidden : false,
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
