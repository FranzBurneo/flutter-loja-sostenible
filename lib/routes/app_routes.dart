import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = '/splash';
  // static const initialRoute = '/home';
  static const routeLogin = '/login';
  static const routeRegister = '/register';
  static const routePrincipal = '/home';

  static Map<String, Widget Function(BuildContext)> routes = {
    '/splash': (BuildContext context) => const SplashScreen(),
    '/login': (BuildContext context) => LoginScreen(),
    '/register': (BuildContext context) => RegisterScreen(),
    '/home': (BuildContext context) => const HomeScreen(),
  };
}
