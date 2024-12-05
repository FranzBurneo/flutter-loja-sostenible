import 'package:flutter/material.dart';
import 'package:loja_sostenible/providers/comments.service.dart';

import 'package:loja_sostenible/routes/app_routes.dart';
import 'package:loja_sostenible/theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:loja_sostenible/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';



Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommentsProvider())
      ],
      child: const MyApp(),
    )
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja Sostenible',
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      theme: AppTheme.ligthTheme,
    );
  }
} 