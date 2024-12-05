import 'package:flutter/material.dart';



class AppTheme {

  static const Color primary = Color(0xFF00796B);
  static const Color secondary = Color(0xFF64B447);
  static const Color blueLS = Color(0xFF3FA9F5);
  static const Color whiteLS = Color(0xFFEAECF1);

  static final ThemeData ligthTheme = ThemeData.light().copyWith(

    primaryColor: primary,

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primary, 
    ),
    
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: secondary),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: secondary),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15)
    ),


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        animationDuration: Duration.zero,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20))
      )
    ), 

  );


  


}