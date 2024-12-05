// ignore: file_names
import 'package:flutter/material.dart';
import 'package:loja_sostenible/screens/screens.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:loja_sostenible/widgets/widgets.dart';

class ButtonsPerfil extends StatelessWidget {
  const ButtonsPerfil({
    super.key,
    required this.size,
  });

  final Size size;

  void _navigateToEditPerfil(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const EditPerfilScreen(),
          );
        },
      ),
    );
  }

  void _navigateToAddPublication(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const AddPublicationScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.height * 0.02),
      child: Column(
        children: [
          CustomButton1(
            texto: 'Agregar Publicación',
            icono: Icons.add,
            bgFondo: AppTheme.primary,
            onPressed: () {
              _navigateToAddPublication(context);
            },
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton1(
                  texto: 'Editar Perfil',
                  icono: Icons.edit,
                  bgFondo: Colors.black54,
                  textStyle: TextStyle(fontSize: 12, color: Colors.white),
                  onPressed: () {
                    _navigateToEditPerfil(context);
                  },
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: CustomButton1(
                  texto: 'Cerrar Sesión',
                  icono: Icons.exit_to_app,
                  bgFondo: Colors.black54,
                  textStyle: TextStyle(fontSize: 12, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
