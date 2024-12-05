import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:loja_sostenible/models/publications.model.dart';
import 'package:loja_sostenible/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:loja_sostenible/providers/publications.service.dart';

class CustomCardFeed extends StatelessWidget {
  final Post? post;

  const CustomCardFeed({
    super.key,
    required this.post,
  });

  void _navigateToDetailPost(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: PostDetailsScreen(post: post!),
          );
        },
      ),
    );
  }

  // Eliminar publicación
  Future<void> _deletePost(BuildContext context) async {
    try {
      final dio = Dio();
      final String apiUrl = "${dotenv.env['BASE_URL_BACK']}/posts/${post!.id}";
      final token = dotenv.env['ACCESS_TOKEN'];

      final response = await dio.delete(
        apiUrl,
        options: Options(
          headers: {
            'x-access-token': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación eliminada')),
        );
        // Recargar publicaciones
        await Provider.of<PublicationsProvider>(context, listen: false)
            .fetchPosts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la publicación')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Mostrar el diálogo de confirmación
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: const Text(
              "¿Estás seguro de que deseas eliminar esta publicación?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                _deletePost(context); // Llamar a la función para eliminar
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  // Ocultar/mostrar publicación
  Future<void> _toggleVisibility(BuildContext context) async {
    try {
      final dio = Dio();
      final String apiUrl = "${dotenv.env['BASE_URL_BACK']}/posts/${post!.id}";
      final token = dotenv.env['ACCESS_TOKEN'];

      final response = await dio.put(
        apiUrl,
        data: {
          'visibility': !post!.visibility,
        },
        options: Options(
          headers: {
            'x-access-token': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(post!.visibility
                ? 'Publicación oculta'
                : 'Publicación visible'),
          ),
        );
        // Recargar publicaciones después de cambiar visibilidad
        Provider.of<PublicationsProvider>(context, listen: false).fetchPosts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cambiar visibilidad')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Mostrar el bottom sheet con las opciones
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  // Lógica de edición
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility),
                title: Text(post!.visibility
                    ? 'Ocultar publicación'
                    : 'Mostrar publicación'),
                onTap: () {
                  _toggleVisibility(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Eliminar'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(
                      context); // Mostrar confirmación antes de eliminar
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Hero(
      tag: post!.id,
      child: InkWell(
        child: Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(size.height * 0.012),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            radius: 22,
                            child: Image(
                              image: NetworkImage(
                                post!.userPost.avatarImage ??
                                    dotenv.env['IMAGE_NOT_FOUND']!,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${post!.userPost.firstname} ${post!.userPost.lastname}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            Text(
                              "${dateFormat.format(post!.dateTimeEvent)} - ${timeFormat.format(post!.dateTimeEvent)}",
                              style: const TextStyle(color: Colors.black38),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        _showBottomSheet(
                            context); // Muestra el modal bottom sheet
                      },
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ],
                ),
              ),
              if (post?.imageUrl != null && post!.imageUrl.isNotEmpty)
                Image(
                  image: NetworkImage(post!.imageUrl),
                  height: size.height * 0.22,
                  fit: BoxFit.cover,
                ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.01),
                child: Text(
                  post!.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Html(
                  data: post!.content,
                  style: {
                    "*": Style(
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: FontSize.medium,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.left,
                      padding: HtmlPaddings.symmetric(vertical: 10),
                      display: Display.inline,
                    ),
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (post!.selectedOds != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(
                              int.parse('0xff${post!.selectedOds!.color}')),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          child: Text(
                            "ODS ${post!.selectedOds!.number}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color:
                            post!.type == 1 ? Colors.blueAccent : Colors.green,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: Text(
                          post!.type == 1 ? 'Blog' : 'Evento',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _navigateToDetailPost(context);
        },
      ),
    );
  }
}
