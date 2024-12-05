import 'package:flutter/material.dart';
import 'package:loja_sostenible/models/ods.model.dart';
import 'package:loja_sostenible/screens/screens.dart';



class CustomCardOds extends StatelessWidget {
  
  final Ods ods;

  const CustomCardOds({
    super.key, 
    required this.ods,
  });


  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: OdsDetailsScreen(ods: ods),
          );
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    if ( ods.logoImage != null ){
      return Hero(
        tag: ods.id,
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(ods.logoImage!),
                fit: BoxFit.cover,
                ), 
            )
          ),
          onTap: () {
            _navigateToDetails(context);
          },
        ),
      );
    }else{
      return const Center(child: CircularProgressIndicator());
    }

  }
}