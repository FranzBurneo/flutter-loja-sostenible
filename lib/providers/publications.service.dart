import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/publications.model.dart';

class PublicationsProvider with ChangeNotifier {
  List<Post> _publications = [];

  List<Post> get publications => _publications;

  // Fetch the list of posts
  Future<void> fetchPosts() async {
    try {
      final dio = Dio();
      final String apiUrl = "${dotenv.env['BASE_URL_BACK']}/posts";
      final token = dotenv.env['ACCESS_TOKEN'];

      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {
            'x-access-token': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsData = response.data['posts'];
        _publications = postsData.map((data) => Post.fromJson(data)).toList();
        notifyListeners(); // Notificar a los listeners que los datos han cambiado
      }
    } catch (e) {
      debugPrint('Error al obtener publicaciones: $e');
    }
  }

  // Eliminar publicación
  Future<void> deletePost(String postId) async {
    try {
      final dio = Dio();
      final String apiUrl = "${dotenv.env['BASE_URL_BACK']}/posts/$postId";
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
        _publications.removeWhere((post) => post.id == postId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al eliminar la publicación: $e');
    }
  }

  // Cambiar visibilidad de la publicación
  Future<void> toggleVisibility(String postId, bool currentVisibility) async {
    try {
      final dio = Dio();
      final String apiUrl = "${dotenv.env['BASE_URL_BACK']}/posts/$postId";
      final token = dotenv.env['ACCESS_TOKEN'];

      final response = await dio.put(
        apiUrl,
        data: {
          'visibility': !currentVisibility,
        },
        options: Options(
          headers: {
            'x-access-token': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        final updatedPost =
            _publications.firstWhere((post) => post.id == postId);
        updatedPost.visibility = !currentVisibility;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al cambiar visibilidad: $e');
    }
  }
}
