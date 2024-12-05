import 'package:flutter/material.dart';
import 'package:loja_sostenible/theme/app_theme.dart';



class CustomInputField2 extends StatelessWidget {

  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final bool? enabled;

  const CustomInputField2({
    super.key, 
    this.hintText, 
    this.labelText,
    this.keyboardType, 
    this.obscureText = false, 
    this.prefixIcon, 
    this.controller, 
    this.enabled
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.05,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        validator: (value){
          if(value!.isEmpty) return "Este campo es obligatorio";
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, color: AppTheme.primary),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), 
            borderSide: BorderSide(color: AppTheme.primary),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppTheme.primary),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppTheme.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15)
        ),
      ),
    );
  }
}