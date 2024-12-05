import 'package:flutter/material.dart';
import 'package:loja_sostenible/models/comment.model.dart';
import 'package:loja_sostenible/providers/comments.service.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Comments extends StatefulWidget {
  final CommentsP comment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Future<void> Function() onSaveEdit;
  final VoidCallback onCancelEdit;
  final TextEditingController editCommentController;
  final bool isEditing;

  const Comments({
    super.key,
    required this.comment,
    required this.onEdit,
    required this.onDelete,
    required this.onSaveEdit,
    required this.onCancelEdit,
    required this.editCommentController,
    required this.isEditing,
  });

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool responseComment = false;
  TextEditingController replyController = TextEditingController();
  List<bool> _responseReplies = [];

  @override
  void initState() {
    super.initState();
    _responseReplies = List<bool>.filled(widget.comment.replies.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final CommentsProvider commentsProvider =
        Provider.of<CommentsProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de comentario principal
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CircleAvatar(
                  radius: 23,
                  backgroundImage:
                      NetworkImage(widget.comment.user.profileImage),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.comment.user.firstname} ${widget.comment.user.lastname}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                      DateFormat('dd/MM/yyyy, HH:mm').format(widget.comment
                          .timestamp), // Agregamos la fecha y hora del comentario
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: size.height * 0.005),
                    if (widget.isEditing)
                      TextField(
                        controller: widget.editCommentController,
                        decoration: const InputDecoration(
                          labelText: 'Editar comentario',
                          border: OutlineInputBorder(),
                        ),
                      )
                    else
                      Text(
                        widget.comment.content,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    widget.onEdit(); // Manejamos la edición desde el padre
                  } else if (value == 'delete') {
                    _showDeleteConfirmationDialog(context);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  ];
                },
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),

          // Mostrar botones de Guardar/Cancelar si estamos en edición
          if (widget.isEditing)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancelEdit,
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () async {
                    await widget.onSaveEdit();

                    // Aquí volvemos a cargar los comentarios para actualizar la pantalla
                    await commentsProvider.getComments(
                        idPublication: widget.comment.postId);

                    setState(() {
                      // Esto asegura que se actualice la UI después de guardar el comentario
                      widget.onCancelEdit();
                    });
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),

          // Botón para responder
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                setState(() {
                  responseComment = !responseComment;
                });
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                textStyle: const TextStyle(fontSize: 14),
              ),
              child: Text(
                responseComment ? 'Cancelar' : 'Responder',
                style: TextStyle(
                    color: responseComment ? Colors.red : AppTheme.primary),
              ),
            ),
          ),

          // Campo para escribir respuesta
          if (responseComment)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: TextField(
                      controller: replyController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Responder...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (replyController.text.length > 2) {
                      await commentsProvider.postReply(
                        idComment: widget.comment.id,
                        content: replyController.text,
                        idPublication: widget.comment.postId,
                      );
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Respuesta agregada con éxito'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      setState(() {
                        responseComment = false;
                        replyController.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                  iconSize: 20,
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints.tightFor(
                    width: 48,
                    height: 48,
                  ),
                  tooltip: 'Responder',
                  splashRadius: 28,
                  splashColor: AppTheme.primary.withOpacity(0.3),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppTheme.primary),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Mostrar el diálogo de confirmación
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este comentario?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                widget.onDelete();
                Navigator.of(context)
                    .pop(); // Cierra el diálogo después de eliminar
              },
            ),
          ],
        );
      },
    );
  }
}
