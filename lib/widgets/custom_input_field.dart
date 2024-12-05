import 'package:flutter/material.dart';
import 'package:loja_sostenible/theme/app_theme.dart';



class CustomInputField extends StatelessWidget {

  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomInputField({
    super.key, 
    this.hintText, 
    this.labelText,
    this.keyboardType, 
    this.obscureText = false, 
    this.prefixIcon, 
    this.controller, 
  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value){
        if(value!.isEmpty) return "Este campo es obligatorio";
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, color: AppTheme.primary)
      ),
    );
  }
}