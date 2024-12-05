import 'package:flutter/material.dart';
import 'package:loja_sostenible/screens/screens.dart';
import 'package:loja_sostenible/theme/app_theme.dart';


class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
    
  }

  _navigateToHome() async{
    await Future.delayed(const Duration(seconds: 2), () {} );
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen() ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteLS,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/Logo/Logo.png'),
          ],
        ),
      ),
    );
  }
}