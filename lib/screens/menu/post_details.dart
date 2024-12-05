import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:loja_sostenible/models/publications.model.dart';
import 'package:loja_sostenible/models/user.model.dart';
import 'package:loja_sostenible/providers/comments.service.dart';
import 'package:loja_sostenible/providers/user.service.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class PostDetailsScreen extends StatefulWidget {
  final Post post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  TextEditingController commentController = TextEditingController();
  User? userActive;
  String? editingCommentId;
  TextEditingController editCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser().then((value) => setState(() {
          commentController.text = '';
          userActive = value;
        }));

    final CommentsProvider commentsProvider =
        Provider.of<CommentsProvider>(context, listen: false);
    commentsProvider.getComments(idPublication: widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    final CommentsProvider commentsProvider =
        Provider.of<CommentsProvider>(context);

    final size = MediaQuery.of(context).size;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Publicación'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Información de la publicación (autor, fecha, imagen, etc.)
              Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        radius: 22,
                        child: Image(
                            image: NetworkImage(
                                widget.post.userPost.avatarImage ??
                                    dotenv.env['IMAGE_NOT_FOUND']!)),
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${widget.post.userPost.firstname} ${widget.post.userPost.lastname}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        Text(
                            "${dateFormat.format(widget.post.dateTimeEvent)} - ${timeFormat.format(widget.post.dateTimeEvent)}",
                            style: const TextStyle(color: Colors.black38))
                      ],
                    ),
                    Expanded(child: Container()),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.share))
                  ],
                ),
              ),
              Image.network(
                widget.post.imageUrl,
                width: size.width,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.01),
                child: Text(widget.post.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Html(
                    data: widget.post.content,
                    style: {
                      "*": Style(
                          fontSize: FontSize.medium,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.justify,
                          padding: HtmlPaddings.symmetric(vertical: 10),
                          display: Display.inline)
                    },
                  )),
              Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: widget.post.selectedOds != null
                              ? Color(int.parse(
                                  '0xff${widget.post.selectedOds!.color}'))
                              : Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: widget.post.selectedOds != null
                            ? Text(widget.post.selectedOds!.title,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white))
                            : const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Comentarios',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  if (userActive != null)
                    Padding(
                      padding: EdgeInsets.all(size.height * 0.01),
                      child: PostComment(
                          size: size,
                          userActive: userActive,
                          commentController: commentController,
                          widget: widget),
                    ),
                  SizedBox(height: size.height * 0.02),
                  Consumer<CommentsProvider>(
                    builder: (context, commentsProvider, child) {
                      return Container(
                        height: size.height * 0.5,
                        child: commentsProvider.comments.isEmpty
                            ? const Center(
                                child: Text('No hay comentarios disponibles.'))
                            : ListView.builder(
                                shrinkWrap: true, // Para ajustar el contenido
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: commentsProvider.comments.length,
                                itemBuilder: (context, index) {
                                  final comment =
                                      commentsProvider.comments[index];
                                  final isEditing =
                                      comment.id == editingCommentId;

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.0002),
                                    child: Comments(
                                      comment: comment,
                                      onEdit: () {
                                        setState(() {
                                          editingCommentId = comment.id;
                                          editCommentController.text =
                                              comment.content;
                                        });
                                      },
                                      onDelete: () async {
                                        await commentsProvider.deleteComment(
                                            idComment: comment.id);
                                        setState(() {
                                          editingCommentId = null;
                                        });
                                      },
                                      onSaveEdit: () async {
                                        await commentsProvider.updateComment(
                                          idComment: comment.id,
                                          content: editCommentController.text,
                                        );
                                        setState(() {
                                          editingCommentId = null;
                                        });
                                      },
                                      onCancelEdit: () {
                                        setState(() {
                                          editingCommentId =
                                              null; // Restablece el estado al cancelar la edición
                                        });
                                      },
                                      isEditing: isEditing,
                                      editCommentController:
                                          editCommentController,
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class PostComment extends StatelessWidget {
  const PostComment({
    super.key,
    required this.size,
    required this.userActive,
    required this.commentController,
    required this.widget,
  });

  final Size size;
  final User? userActive;
  final TextEditingController commentController;
  final PostDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    final CommentsProvider commentsProvider =
        Provider.of<CommentsProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(size.height * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(userActive!.avatarImage),
              backgroundColor: Colors.grey[
                  200], // Asegurarse de que tenga un fondo en caso de error
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tú (${userActive!.firstname} ${userActive!.lastname})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  child: TextField(
                    controller: commentController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Comentar...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.02),
          IconButton(
            onPressed: () async {
              if (commentController.text.length > 2) {
                await commentsProvider.postComment(
                    idPublication: widget.post.id,
                    content: commentController.text);
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Comentario agregado con éxito'),
                  duration: Duration(seconds: 2),
                ));
                commentController.clear();
              }
            },
            icon: const Icon(Icons.send),
            color: Colors.white,
            iconSize: 24, // Aumentar el tamaño para mejor visibilidad
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints.tightFor(
              width: 48,
              height: 48,
            ),
            tooltip: 'Comentar',
            splashRadius: 28,
            splashColor: AppTheme.primary.withOpacity(0.3),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
