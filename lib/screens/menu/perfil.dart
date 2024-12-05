import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/forms.model.dart';
import 'package:loja_sostenible/models/publications.model.dart';
import 'package:loja_sostenible/models/user.model.dart';
import 'package:loja_sostenible/providers/user.service.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:loja_sostenible/widgets/widgets.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key, required this.navigatorKey});

  final GlobalKey navigatorKey;

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  List<Post> postsList = [];
  List<Forms> formsList = [];
  User? userActive;

  @override
  void initState() {
    super.initState();
    getOwnPosts();
    getForms();
    getUser().then((value) => setState(() {
          userActive = value;
        }));
  }

  Future<List<Forms>> getForms() async {
    print("---GET FORMS---");
    final dio = Dio();

    // Configura los encabezados, incluyendo el token dinámico
    final Map<String, String> headers = {
      'x-access-token': dotenv.env['ACCESS_TOKEN'].toString()
    };

    dio.options.headers = headers;

    // Verifica si userActive es nulo antes de acceder a userId
    if (userActive == null || userActive!.userId == null) {
      print("Error: No se ha encontrado un usuario activo.");
      print(userActive);
      throw Exception("No se ha encontrado un usuario activo.");
    }

    // Ruta para obtener los formularios
    final String ruta = "${dotenv.env['BASE_URL_BACK']}/forms";

    // Realiza la solicitud GET con los parámetros adecuados
    final response = await dio.get(ruta, queryParameters: {
      'iterator': 0,
      'onlyOwnPosts': true, // Asumiendo que solo quieres tus propios posts
      'userId': userActive!.userId
    });

    // Verifica la respuesta del servidor
    if (response.statusCode == 200) {
      print("Response data: ${response.data}");

      // Procesa la respuesta y devuelve la lista de formularios
      final jsonBody = response.data;
      final formsListJson = jsonBody['forms'] as List;
      formsList = formsListJson.map((e) => Forms.fromJson(e)).toList();

      print("Número de formularios obtenidos: ${formsList.length}");

      return formsList;
    } else {
      throw Exception(
          "Error al obtener los formularios. Código de estado: ${response.statusCode}");
    }
  }

  Future<List<Post>> getOwnPosts() async {
    final dio = Dio();

    // Configura los encabezados, incluyendo el token dinámico
    final Map<String, String> headers = {
      'x-access-token': dotenv.env['ACCESS_TOKEN'].toString()
    };

    dio.options.headers = headers;

    // Verifica si userActive es nulo antes de acceder a userId
    if (userActive == null || userActive!.userId == null) {
      print("Error: No se ha encontrado un usuario activo.");
      print(userActive);
      throw Exception("No se ha encontrado un usuario activo.");
    }

    // La ruta está fija para las publicaciones del propio usuario
    final String ruta = "${dotenv.env['BASE_URL_BACK']}/posts/ownPosts";
    print("Ruta: $ruta");

    // Realiza la solicitud GET con los parámetros adecuados
    final response = await dio.get(ruta, queryParameters: {
      'iterator': 0,
      'onlyOwnPosts': true,
      'userId': userActive!.userId, // Acceso seguro a userId
      'type': 1
    });

    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");

    // Procesa la respuesta y devuelve la lista de publicaciones
    final jsonBody = response.data;
    final postsListJson = jsonBody['posts'] as List;
    postsList = postsListJson.map((e) => Post.fromJson(e)).toList();

    print("Número de publicaciones obtenidas: ${postsList.length}");

    return postsList;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight:
                  350.0, // Mantener la altura para mostrar los botones y la imagen de perfil
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(userActive?.avatarImage ??
                          dotenv.env['IMAGE_NOT_FOUND']!),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${userActive?.firstname ?? ''} ${userActive?.lastname ?? ''}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Botones como Agregar Publicación, Editar Perfil y Cerrar Sesión
                    ButtonsPerfil(size: MediaQuery.of(context).size),
                  ],
                ),
              ),
            ),
          ];
        },
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                labelColor: AppTheme.primary,
                indicatorColor: AppTheme.primary,
                tabs: [
                  Tab(child: Text('Publicaciones')),
                  Tab(child: Text('Encuestas'))
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder(
                      future: getOwnPosts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(3),
                                child: CustomCardFeed(post: postsList[index]),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    FutureBuilder(
                      future: getForms(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(3),
                                child: CustomCardFeed2(
                                  form: formsList[index],
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
