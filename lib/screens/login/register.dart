import 'package:flutter/material.dart';
import 'package:loja_sostenible/routes/app_routes.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:loja_sostenible/widgets/widgets.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {

  TextEditingController nombresController = TextEditingController(text: '');
  TextEditingController apellidosController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController password2Controller = TextEditingController(text: '');

  RegisterScreen({super.key});

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
                    height: 50,
                  ),
                  const Image(
                    image: AssetImage('assets/img/Logo/Logo.png'),
                    height: 60,
                  ),
                  const Text(
                    'Loja Sostenible',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInputField(
                    controller: nombresController,
                    labelText: 'Nombres',
                    hintText: 'Nombres',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomInputField(
                    controller: apellidosController,
                    labelText: 'Apellidos',
                    hintText: 'Apellidos',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomInputField(
                    controller: emailController,
                    labelText: 'Correo Electronico',
                    hintText: 'Correo Electronico',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.alternate_email,
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
                    height: 15,
                  ),
                  CustomInputField(
                    controller: password2Controller,
                    labelText: 'Confirmar Contraseña',
                    hintText: 'Confirmar Contraseña',
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
                    onPressed: (){}, 
                    child: const SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Center( 
                        child: Text('Registrar', 
                          style: TextStyle( 
                            color: AppTheme.whiteLS, 
                            fontSize: 16
                          ),
                        )
                      ),
                    ), 
                  ),
                  const SizedBox(
                    height: 20,
                  ), 
                  const SocialButtons(),
                  const SizedBox(
                    height: 30
                  ),
                  const Text('¿Ya tienes una Cuenta?'),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, AppRoutes.routeLogin);
                  }, 
                    child: const Text(
                      'Iniciar Sesion',
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

