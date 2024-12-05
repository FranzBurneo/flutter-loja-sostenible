import 'package:flutter/material.dart';
import 'package:loja_sostenible/models/ods.model.dart';
import 'package:loja_sostenible/screens/screens.dart';

class CardsSliderOds extends StatelessWidget {

  final Ods ods;

  const CardsSliderOds({
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

    final size = MediaQuery.of(context).size;
    if ( ods.logoImage != null ){
      return InkWell(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: size.width * 0.30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              image: NetworkImage(ods.logoImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        onTap: () {
          _navigateToDetails(context);
        },
      );
    }else{
      return const Center(child: CircularProgressIndicator());
    }
  }
}