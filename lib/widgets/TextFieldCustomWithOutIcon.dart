import 'package:college_minor_project_frontend/constants/AppStyle.dart';
import 'package:flutter/material.dart';

class TextFieldCustomWithOutIcon extends StatelessWidget {

  TextEditingController controller;
  TextInputType keyboardType;
  bool obscureText;
  String hintText;
  Widget? suffixIcon;
  String? Function(String?)? validator;
  int maxLines;
  bool readOnly;
  Function()? onTap;

  TextFieldCustomWithOutIcon({
    required this.controller,
    required this.keyboardType,
    this.obscureText = false,
    required this.hintText,
    this.suffixIcon,
    required this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: AppStyle.white,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(
        color: AppStyle.white,
      ),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppStyle.grey,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyle.purple_light_2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyle.purple_light_2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyle.red_dark,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyle.red_dark,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
