import 'package:college_minor_project_frontend/constants/AppStyle.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {

  TextEditingController controller;
  TextInputType keyboardType;
  IconData icon;
  bool obscureText;
  String hintText;
  Widget? suffixIcon;
  String? Function(String?)? validator;
  int maxLines;

  TextFieldCustom({
    required this.controller,
    required this.keyboardType,
    required this.icon,
    this.obscureText = false,
    required this.hintText,
    this.suffixIcon,
    required this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: AppStyle.white,
      maxLines: maxLines,
      style: TextStyle(
        color: AppStyle.white,
      ),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppStyle.grey,
        ),
        prefixIcon: Icon(icon, color: AppStyle.white,),
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
