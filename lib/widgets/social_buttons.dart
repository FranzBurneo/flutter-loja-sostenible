import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: (){}, 
          child: const Image(
            image:AssetImage('assets/img/Logo/Google.png'),
            fit: BoxFit.cover,
            height: 35,
          )
        ),
        TextButton(
          onPressed: (){}, 
          child: const Image(
            image:AssetImage('assets/img/Logo/Facebook.png'),
            fit: BoxFit.cover,
            height: 35,
          )
        ),
        
      ],
    );
  }
}