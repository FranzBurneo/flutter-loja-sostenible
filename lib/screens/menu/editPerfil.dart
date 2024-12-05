import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/user.model.dart';
import 'package:loja_sostenible/providers/user.service.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:loja_sostenible/widgets/widgets.dart';

// ignore: must_be_immutable
class EditPerfilScreen extends StatefulWidget {
  const EditPerfilScreen({super.key});

  @override
  State<EditPerfilScreen> createState() => _EditPerfilScreenState();
}

class _EditPerfilScreenState extends State<EditPerfilScreen> {
  User? userActive;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser().then((value) {
      setState(() {
        userActive = value;
        emailController.text = userActive?.email ?? '';
        nameController.text = userActive?.firstname ?? '';
        lastNameController.text = userActive?.lastname ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(fontSize: 20)),
      ),
      body: FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 30,
                              child: Image(
                                  image: NetworkImage(userActive?.avatarImage ??
                                      dotenv.env['IMAGE_NOT_FOUND']!)),
                            )),
                        SizedBox(width: size.width * 0.03),
                        Text("${userActive?.firstname} ${userActive?.lastname}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    CustomInputField2(
                      hintText: 'Correo',
                      labelText: 'Correo',
                      prefixIcon: Icons.email,
                      controller: emailController,
                      enabled: false,
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    CustomInputField2(
                      hintText: 'Nombres',
                      labelText: 'Nombres',
                      prefixIcon: Icons.person,
                      controller: nameController,
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    CustomInputField2(
                      hintText: 'Apellidos',
                      labelText: 'Apellidos',
                      prefixIcon: Icons.person_2_outlined,
                      controller: lastNameController,
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    CustomInputField2(
                      hintText: 'Contraseña Nueva',
                      labelText: 'Contraseña Nueva',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      controller: password1Controller,
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    CustomInputField2(
                      hintText: 'Repetir Contraseña',
                      labelText: 'Repetir Contraseña',
                      prefixIcon: Icons.lock_open,
                      obscureText: true,
                      controller: password2Controller,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomButton1(
                      bgFondo: AppTheme.primary,
                      icono: Icons.edit_outlined,
                      texto: 'Actualizar',
                      onPressed: () async {
                        final message = await updateUser(
                          firstname: nameController.text,
                          lastname: lastNameController.text,
                          password1: password1Controller.text,
                          password2: password2Controller.text,
                        );
                        if (message == 'Usuario actualizado correctamente') {
                          final user = await getUser();
                          setState(() {
                            userActive = user;
                            nameController.text = userActive?.firstname ?? '';
                            lastNameController.text =
                                userActive?.lastname ?? '';
                          });
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
