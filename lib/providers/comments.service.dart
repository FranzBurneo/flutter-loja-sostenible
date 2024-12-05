import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/comment.model.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentsP> _comments = [];

  List<CommentsP> get comments => _comments;

  // Obtener comentarios de una publicación
  Future<void> getComments({String? idPublication}) async {
    final comments = await getCommentsService(idPublication: idPublication);
    _comments = comments;
    print("Updated comments list: $_comments");
    notifyListeners();
  }

  // Crear un nuevo comentario
  Future<void> postComment({String? idPublication, String? content}) async {
    final message = await postCommentService(
        idPublication: idPublication, content: content);
    if (message == 'Created') {
      await getComments(idPublication: idPublication);
    }
  }

  // Crear una respuesta a un comentario
  Future<void> postReply(
      {String? idPublication, String? idComment, String? content}) async {
    final message =
        await postReplyService(idComment: idComment, content: content);
    if (message == 'Created') {
      await getComments(idPublication: idPublication);
    }
  }

  // Actualizar comentario existente
  Future<void> updateComment(
      {required String idComment,
      required String content,
      String? idPublication}) async {
    final message =
        await updateCommentService(idComment: idComment, content: content);
    if (message == 'Updated') {
      notifyListeners();
    }
  }

  // Eliminar comentario
  Future<void> deleteComment({required String idComment}) async {
    final message = await deleteCommentService(idComment: idComment);
    if (message == 'Deleted') {
      _comments.removeWhere((comment) => comment.id == idComment);
      notifyListeners();
    }
  }
}

//TODO: cambiar debe ser dinamico el token
final Map<String, String> headers = {
  'x-access-token': dotenv.env['ACCESS_TOKEN'].toString()
};
final String urlComment = "${dotenv.env['BASE_URL_BACK']}/comments";

// Servicio para crear un nuevo comentario
Future<String> postCommentService({
  String? idPublication,
  String? content,
}) async {
  final dio = Dio();
  late String messageResponse;

  if (idPublication == null) return "No existe id de Publicación";
  if (content == null) return "No existe contenido del comentario";

  final data = {
    'postId': idPublication,
    'content': content,
  };

  dio.options.headers = headers;
  final response = await dio.post(urlComment, data: data);

  if (response.statusCode == 201) {
    messageResponse = response.statusMessage.toString();
  } else {
    messageResponse = 'Error al crear comentario';
  }

  return messageResponse;
}

// Servicio para actualizar un comentario existente
Future<String> updateCommentService({
  required String idComment,
  required String content,
}) async {
  final dio = Dio();
  late String messageResponse;

  if (content.isEmpty) return "No existe contenido del comentario";

  final data = {
    'content': content,
  };

  dio.options.headers = headers;
  final response = await dio.put('$urlComment/$idComment', data: data);

  if (response.statusCode == 200) {
    messageResponse = "Updated";
  } else {
    messageResponse = 'Error al actualizar comentario';
  }

  return messageResponse;
}

// Servicio para eliminar un comentario
Future<String> deleteCommentService({required String idComment}) async {
  final dio = Dio();
  late String messageResponse;

  dio.options.headers = headers;
  final response = await dio.delete('$urlComment/$idComment');

  if (response.statusCode == 200) {
    messageResponse = "Deleted";
  } else {
    messageResponse = 'Error al eliminar comentario';
  }

  return messageResponse;
}

// Servicio para obtener los comentarios de una publicación
Future<List<CommentsP>> getCommentsService({String? idPublication}) async {
  List<CommentsP> commentsList = [];
  final dio = Dio();

  final Map<String, String> headers = {
    'x-access-token': dotenv.env['ACCESS_TOKEN'].toString()
  };

  dio.options.headers = headers;

  final response =
      await dio.get("${dotenv.env['BASE_URL_BACK']}/comments/$idPublication");
  final jsonBody = response.data;
  final commentsListJson = jsonBody['comments'] as List;
  commentsList = commentsListJson.map((e) => CommentsP.fromJson(e)).toList();
  return commentsList;
}

// Servicio para crear una respuesta a un comentario
Future<String> postReplyService({
  String? idComment,
  String? content,
}) async {
  final dio = Dio();
  late String messageResponse;

  if (idComment == null) return "No existe id de Comentario";
  if (content == null) return "No existe contenido de la respuesta";

  final data = {
    'content': content,
  };

  dio.options.headers = headers;
  final response = await dio.post('$urlComment/$idComment/reply', data: data);

  if (response.statusCode == 201) {
    messageResponse = response.statusMessage.toString();
  } else {
    messageResponse = 'Error al crear respuesta';
  }

  return messageResponse;
}
