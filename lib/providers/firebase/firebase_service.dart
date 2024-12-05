import 'package:firebase_auth/firebase_auth.dart';

Future<String?> login(String email, String password) async {

  try{

    // await FirebaseAuth.instance.signInWithEmailAndPassword(
    //   email: email, password: password
    // );

    return null;

  }on FirebaseAuthException catch(ex){
    if (ex.code == 'user-not-found' ) {
      return 'Usuario no encontrado';
    }else if(ex.code == 'wrong-password'){
      return 'Contraseña Incorrecta';
    }else if(ex.code == 'invalid-email'){
      return 'Email invalido';
    }else if(ex.code == 'channel-error'){
      return 'Ingrese su usuario y contraseña'; 
    }else if(ex.code == 'invalid-credential'){
      return 'Credenciales Invalidas';
    }
    return 'Error desconocido';
  }
  
}