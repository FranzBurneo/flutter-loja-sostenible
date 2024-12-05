import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton1 extends StatelessWidget {
  final String texto;
  final IconData? icono;
  final Color? bgFondo;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  const CustomButton1({
    super.key,
    required this.texto,
    this.icono,
    this.bgFondo,
    this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgFondo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Colors.white),
            SizedBox(width: size.width * 0.02),
            Text(
              texto,
              style: textStyle ??
                  const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
