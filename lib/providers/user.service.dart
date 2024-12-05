import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/user.model.dart';

// * Se puede hacer con la libreria shared_preferences
//TODO: cambiar debe ser dinamico el token
final Map<String, String> headers = {
  'x-access-token': dotenv.env['ACCESS_TOKEN'].toString()
};

final String urlUser = "${dotenv.env['BASE_URL_BACK']}/users/byToken";

Future<User> getUser() async {
  final dio = Dio();

  dio.options.headers = headers;

  // Hacemos la petición al servidor
  final response = await dio.get(urlUser);

  // Mostramos el status y la data de la respuesta
  print("Response status: ${response.statusCode}");
  print("Response data: ${response.data}");

  if (response.statusCode == 200) {
    final jsonBody = response.data;
    final userActive = User.fromJson(jsonBody['user']);
    print("Usuario encontrado: ${userActive.userId}");
    return userActive;
  } else {
    throw Exception(
        "Error al obtener el usuario. Código de estado: ${response.statusCode}");
  }
}

Future<String> updateUser({
  String? firstname,
  String? lastname,
  String? password1,
  String? password2,
}) async {
  final dio = Dio();
  late String messageStatus;

  if (firstname != null || lastname != null) {
    Map<String, String> data = {};

    if (firstname != null) {
      data['firstname'] = firstname;
    }

    if (lastname != null) {
      data['lastname'] = lastname;
    }

    if (password1 != null && password2 != null) {
      if (password1.length < 8) {
        messageStatus = 'Tiene que ser mayor a 8 caracteres';
        return messageStatus;
      }
      ;

      if (password1 == password2) {
        data['password'] = password1;
      } else {
        messageStatus = 'Las contraseñas no coinciden';
        return messageStatus;
      }
    } else {
      messageStatus = 'Debe rellenar los dos campos';
    }

    dio.options.headers = headers;
    final response = await dio.put(urlUser, data: data);

    if (response.statusCode == 200) {
      messageStatus = 'Usuario actualizado correctamente';
    } else {
      messageStatus = 'Error al actualizar el usuario';
    }
  } else {
    messageStatus =
        'No se proporcionaron parámetros para actualizar el usuario';
  }

  return messageStatus;
}
