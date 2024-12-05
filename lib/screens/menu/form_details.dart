import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:loja_sostenible/models/forms.model.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:dio/dio.dart';

class FormDetailsScreen extends StatefulWidget {
  final Forms form;

  const FormDetailsScreen({super.key, required this.form});

  @override
  State<FormDetailsScreen> createState() => _FormDetailsScreenState();
}

class _FormDetailsScreenState extends State<FormDetailsScreen> {
  final Map<int, dynamic> responses =
      {}; // Para almacenar las respuestas de los usuarios

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Formulario de Encuesta'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Contenedor tu rquesa para el título y la información del usuario
              Container(
                color: AppTheme.primary, // Usa el color turquesa de tu tema
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Imagen del usuario
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.form.userPost.avatarImage),
                      radius: 25,
                    ),
                    const SizedBox(width: 12),
                    // Información del usuario y fecha
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.form.userPost.firstname} ${widget.form.userPost.lastname}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy, HH:mm')
                              .format(widget.form.timestamp),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {}, // Acción para compartir o más opciones
                      icon: const Icon(Icons.share, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y descripción de la encuesta
                    Text(
                      widget.form.title,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(widget.form.description,
                        style: const TextStyle(fontSize: 16)),
                    const Divider(height: 30),

                    // Mostrar todas las preguntas
                    ...widget.form.questions.map((question) {
                      return _buildQuestionWidget(question);
                    }).toList(),

                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitResponses,
                        child: const Text('Enviar Respuestas'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.1,
                            vertical: size.height * 0.02,
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                          backgroundColor:
                              AppTheme.primary, // Color de fondo turquesa
                          foregroundColor: Colors.white, // Texto en blanco
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: null,
      ),
    );
  }

  // Widget para cada pregunta
  Widget _buildQuestionWidget(Question question) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la pregunta con color turquesa
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme
                    .primary, // Aplica el color turquesa a las preguntas
              ),
            ),
            const SizedBox(height: 10),
            if (question.type == 1) _buildSingleChoiceQuestion(question),
            if (question.type == 2) _buildMultipleChoiceQuestion(question),
            if (question.type == 3) _buildTextFieldQuestion(question),
          ],
        ),
      ),
    );
  }

  // Pregunta de opción múltiple
  Widget _buildMultipleChoiceQuestion(Question question) {
    List<Option> options = widget.form.options
        .where((option) => option.idQuestion == question.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...options.map((option) {
          return CheckboxListTile(
            title: Text(option.description),
            value: (responses[question.id] as List<dynamic>?)
                    ?.contains(option.id) ??
                false,
            onChanged: (isSelected) {
              setState(() {
                if (isSelected == true) {
                  responses.putIfAbsent(question.id, () => []).add(option.id);
                } else {
                  responses[question.id]?.remove(option.id);
                }
              });
            },
          );
        }).toList(),
      ],
    );
  }

  // Pregunta de respuesta única (radio buttons)
  Widget _buildSingleChoiceQuestion(Question question) {
    List<Option> options = widget.form.options
        .where((option) => option.idQuestion == question.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...options.map((option) {
          return RadioListTile<int>(
            title: Text(option.description),
            value: option.id,
            groupValue: responses[question.id],
            onChanged: (value) {
              setState(() {
                responses[question.id] = value;
              });
            },
          );
        }).toList(),
      ],
    );
  }

// Pregunta de texto libre
  Widget _buildTextFieldQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Escribe tu respuesta aquí...',
          ),
          maxLines: null, // Permite que crezca verticalmente
          minLines: 1, // Muestra al menos 1 línea al inicio
          onChanged: (value) {
            setState(() {
              responses[question.id] = value;
            });
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Función para enviar las respuestas
  void _submitResponses() async {
    final Map<String, dynamic> sendRequest = {
      'formId':
          widget.form.id ?? '', // Asignar un valor predeterminado si es null
      'userId': widget.form.userPost.userId ?? '',
      'verifiedUser': false,
      'questions': widget.form.questions.map((question) {
        List<Option> selectedOptions = widget.form.options.where((option) {
          final response = responses[question.id];
          if (response is List) {
            return response.contains(option.id);
          }
          if (response is int) {
            return response == option.id;
          }
          return false;
        }).toList();

        return {
          'question': question.question ?? '',
          'id': question.id,
          'type': question.type,
          'answeredId': responses[question.id] is List<dynamic>
              ? responses[question.id]
              : responses[question.id],
          'answeredText': question.type == 1 && selectedOptions.isNotEmpty
              ? selectedOptions.first.description
              : selectedOptions.isNotEmpty
                  ? selectedOptions.map((option) => option.description).toList()
                  : responses[question.id] is String
                      ? responses[question.id]
                      : null, // Para texto libre y otras respuestas
        };
      }).toList(),
    };

    print('JSON de respuestas antes de enviar: $sendRequest');

    // Configuración de la solicitud con Dio
    Dio dio = Dio();
    String token = dotenv.env['ACCESS_TOKEN'].toString();
    dio.options.headers["x-access-token"] = token;
    final String ruta = "${dotenv.env['BASE_URL_BACK']}/answerForms";
    print(ruta);
    try {
      final response = await dio.post(
        ruta,
        data: sendRequest,
      );

      print('Respuesta del servidor: ${response.data}'); // Para depurar

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Respuesta enviada con éxito')),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/publicaciones',
          (Route<dynamic> route) =>
              false, // Elimina todas las pantallas anteriores
        );
      } else {
        throw Exception('Error en la solicitud: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar las respuestas')),
      );
    }
  }
}
