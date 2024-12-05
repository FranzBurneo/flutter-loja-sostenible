import 'package:flutter/material.dart';
import 'package:loja_sostenible/providers/firebase/firebase_service.dart';
import 'package:loja_sostenible/routes/app_routes.dart';
import 'package:loja_sostenible/screens/screens.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:loja_sostenible/widgets/widgets.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {

  TextEditingController userController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: AppTheme.whiteLS,
              image: DecorationImage(
                image: AssetImage('assets/img/Design/backgroundLogin.png'),
                fit: BoxFit.cover,
                opacity: 0.05
              )
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Loja Sostenible',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Image(
                    image: AssetImage('assets/img/Logo/Logo.png'),
                    height: 140,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomInputField(
                    controller: userController,
                    labelText: 'Correo Electronico',
                    hintText: 'Correo Electronico',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomInputField(
                    controller: passwordController,
                    labelText: 'Contraseña',
                    hintText: 'Contraseña',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                    ),
                    onPressed: () async{
                      String? errorMessage = await login(userController.text, passwordController.text);
                      if(errorMessage == null){
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), 
                                (Route<dynamic> route) => false);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                          ),
                        );
                      }
                    }, 
                    child: const SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Center( 
                        child: Text('Ingresar', 
                          style: TextStyle( 
                            color: AppTheme.whiteLS, 
                            fontSize: 16
                          ),
                        )
                      ),
                    ), 
                  ),
                  const SizedBox(
                    height: 35,
                  ), 
                  const SocialButtons(),
                  const SizedBox(
                    height: 50
                  ),
                  const Text('¿No Tienes una cuenta?'),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, AppRoutes.routeRegister);
                  }, 
                    child: const Text(
                      'Crea Una',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}

