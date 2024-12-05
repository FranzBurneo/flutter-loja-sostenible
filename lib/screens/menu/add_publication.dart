import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:loja_sostenible/widgets/widgets.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SurveyForm extends StatefulWidget {
  final Function(List<Question>)
      onQuestionsUpdated; // Callback para enviar las preguntas al componente principal

  const SurveyForm({Key? key, required this.onQuestionsUpdated})
      : super(key: key);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  List<Question> questions = [];
  QuestionType selectedQuestionType = QuestionType.singleChoice;

  @override
  void initState() {
    super.initState();
    addNewQuestion();
  }

  void addNewQuestion() {
    setState(() {
      questions.add(Question(
        id: questions.length + 1,
        text: 'Pregunta sin título',
        type: QuestionType.singleChoice,
        options: [Option(id: 1, text: 'Opción 1')],
      ));
      widget.onQuestionsUpdated(
          questions); // Llamar el callback al actualizar las preguntas
    });
  }

  void addOption(int questionId) {
    setState(() {
      final question = questions.firstWhere((q) => q.id == questionId);
      question.options.add(Option(id: question.options.length + 1, text: ''));
      widget.onQuestionsUpdated(
          questions); // Llamar el callback al actualizar las preguntas
    });
  }

  void deleteOption(int questionId, int optionId) {
    setState(() {
      final question = questions.firstWhere((q) => q.id == questionId);
      question.options.removeWhere((opt) => opt.id == optionId);
      widget.onQuestionsUpdated(
          questions); // Llamar el callback al actualizar las preguntas
    });
  }

  void deleteQuestion(int questionId) {
    setState(() {
      questions.removeWhere((q) => q.id == questionId);
      widget.onQuestionsUpdated(
          questions); // Llamar el callback al actualizar las preguntas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            'Preguntas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...questions.map((question) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Pregunta sin título',
                            labelStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              question.text = value;
                              widget.onQuestionsUpdated(
                                  questions); // Llamar el callback al actualizar las preguntas
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteQuestion(question.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<QuestionType>(
                    value: question.type,
                    onChanged: (newValue) {
                      setState(() {
                        question.type = newValue!;
                        widget.onQuestionsUpdated(
                            questions); // Llamar el callback al actualizar las preguntas
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: QuestionType.singleChoice,
                        child: Text('Opción múltiple'),
                      ),
                      DropdownMenuItem(
                        value: QuestionType.multipleChoice,
                        child: Text('Varias respuestas'),
                      ),
                      DropdownMenuItem(
                        value: QuestionType.textField,
                        child: Text('Texto libre'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (question.type == QuestionType.textField)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Texto libre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        ...question.options.map((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                if (question.type == QuestionType.singleChoice)
                                  const Radio(
                                      value: true,
                                      groupValue: null,
                                      onChanged: null),
                                if (question.type ==
                                    QuestionType.multipleChoice)
                                  const Checkbox(value: true, onChanged: null),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Opción ${option.id}',
                                      border: const OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        option.text = value;
                                        widget.onQuestionsUpdated(
                                            questions); // Llamar el callback al actualizar las preguntas
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    deleteOption(question.id, option.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        TextButton.icon(
                          onPressed: () => addOption(question.id),
                          icon: const Icon(Icons.add),
                          label: const Text('Agrega opción'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            iconSize: 60,
            color: AppTheme.primary,
            onPressed: addNewQuestion,
            icon: const Icon(Icons.add_circle),
          ),
        )
      ],
    );
  }
}

// Modelos para preguntas y opciones
class Question {
  int id;
  String text; // Atributo de texto
  QuestionType type;
  List<Option> options;

  Question(
      {required this.id,
      required this.text,
      required this.type,
      required this.options});
}

class Option {
  int id;
  String text; // Atributo de texto

  Option(
      {required this.id,
      required this.text}); // Se incluye 'text' en el constructor
}

enum QuestionType {
  singleChoice,
  multipleChoice,
  textField,
}

class AddPublicationScreen extends StatefulWidget {
  const AddPublicationScreen({super.key});

  @override
  State<AddPublicationScreen> createState() => _AddPublicationScreenState();
}

class _AddPublicationScreenState extends State<AddPublicationScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  List<PlatformFile>? attachments;
  int selectedOption = 1;
  int? selectedItem = 1;
  int? selectedItemForm = 1;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

  HtmlEditorController editorHtmlController = HtmlEditorController();
  TextEditingController titleController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  int? interactionType = 1; // Para manejar el valor seleccionado
  List<Map<String, String>> odsData = [];
  String? selectedOds;
  // Variables para las fechas y horas formateadas
  String formattedDate = '';
  String formattedTime = '';
  List<Question> questions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    formattedTime = selectedTime.format(context);
  }

  void initState() {
    super.initState();
    fetchOdsData();
  }

  // Actualizar preguntas desde el SurveyForm
  void _updateQuestions(List<Question> newQuestions) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        questions = newQuestions; // Aquí actualizas las preguntas
      });
    });
  }

  // Método para cargar los datos de ODS desde la API
  Future<void> fetchOdsData() async {
    try {
      print("----⭕ FETCH ODS DATA ---");

      final dio = Dio();
      String token = dotenv.env['ACCESS_TOKEN'].toString();
      dio.options.headers["x-access-token"] = token;
      final String ruta = "${dotenv.env['BASE_URL_BACK']}/ods";

      final response = await dio.get(ruta);
      if (response.statusCode == 200) {
        final odsList = response.data['ods'] as List;
        setState(() {
          odsData = odsList
              .map((e) => {
                    "id": e["id"].toString(),
                    "name": e["name"].toString(),
                  })
              .toList();
        });
      }
    } catch (e) {
      print("Error al cargar los ODS: $e");
    }
  }

  Future<void> _pickDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
        formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
        print(
            "Fecha seleccionada: $formattedDate"); // Verificar si se está actualizando
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
        formattedTime = selectedTime.format(context);
        print(
            "Hora seleccionada: $formattedTime"); // Verificar si se está actualizando
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickAttachments() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        attachments = result.files;
      });
    }
  }

  Future<void> _submitPost() async {
    if (selectedItem == 3) {
      // Si es una encuesta
      // Estructura de preguntas para enviar
      List<Map<String, dynamic>> questionsData = questions.map((question) {
        return {
          "id": question.id,
          "question": question.text,
          "type": question.type.index + 1, // Mapea el tipo al número adecuado
        };
      }).toList();

      // Estructura de opciones para enviar
      List<Map<String, dynamic>> optionsData = [];
      questions.forEach((question) {
        optionsData.addAll(question.options.map((option) {
          return {
            "id": option.id,
            "description": option.text,
            "idQuestion": question.id
          };
        }).toList());
      });

      // Crea el objeto con los datos de la encuesta
      Map<String, dynamic> formData = {
        "title": titleController.text,
        "description": placeController
            .text, // Este campo será la descripción de la encuesta
        "selectedOds": selectedOds,
        "interactionType": interactionType,
        "questions": questionsData,
        "options": optionsData
      };

      print("🟢 Form data (encuesta): $formData");

      // Configura el cliente dio para hacer la solicitud HTTP a /forms
      Dio dio = Dio();
      String token = dotenv.env['ACCESS_TOKEN'].toString();
      dio.options.headers["x-access-token"] = token;
      final String ruta = "${dotenv.env['BASE_URL_BACK']}/forms";

      try {
        final response = await dio.post(
          ruta,
          data: formData,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("Encuesta creada con éxito: ${response.data}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Encuesta creada con éxito')),
          );
          Navigator.pop(
              context); // Regresar a la pantalla anterior después de crear la encuesta
        } else {
          throw Exception('Error en la solicitud: ${response.statusMessage}');
        }
      } catch (e) {
        print("Error al crear la encuesta: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la encuesta')),
        );
      }
    } else {
      // Código para crear publicaciones normales (blogs o eventos) en la ruta de /posts
      await _submitPostToPosts();
    }
  }

  Future<void> _submitPostToPosts() async {
    String content = await editorHtmlController.getText();
    String summaryContent = content.length > 50
        ? content.substring(0, 50)
        : content; // Genera un resumen
    Map<String, String>? imageData;

    if (_imageFile != null) {
      // Leer los bytes de la imagen
      String imageBase64 = base64Encode(await _imageFile!.readAsBytes());
      String imageExtension =
          _imageFile!.path.split('.').last; // Obtener la extensión del archivo

      // Preparar la imagen en el formato esperado
      imageData = {
        "fileName": _imageFile!.path.split('/').last,
        "image": "data:image/$imageExtension;base64,$imageBase64"
      };
    }

    // Convertir adjuntos a base64 y añadir el contentType
    List<Map<String, String>> attachmentsData = [];
    if (attachments != null) {
      for (var file in attachments!) {
        String fileBase64 = base64Encode(await File(file.path!).readAsBytes());
        String fileExtension = file.extension ?? "txt"; // Obtener la extensión
        String contentType =
            _getContentType(fileExtension); // Obtener el tipo MIME

        attachmentsData.add({
          "fileName": file.name,
          "fileContent": "data:application/$fileExtension;base64,$fileBase64",
          "contentType": contentType
        });
      }
    }

    // Formatear fecha y hora para DateTimeEvent
    final DateTime fullDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Crea el objeto con los datos de la publicación
    Map<String, dynamic> postData = {
      "title": titleController.text,
      "content": content,
      "DateTimeEvent": selectedItem == 2 ? fullDateTime.toIso8601String() : "",
      "attachments": attachmentsData,
      "image": imageData,
      "interactionType":
          interactionType, // Valor seleccionado del tipo de interacción
      "place": selectedItem == 2 ? placeController.text : "",
      "selectedOds": selectedOds, // Valor seleccionado del ODS
      "summaryContent": summaryContent,
      "type": selectedItem // 1 para blog, 2 para eventos, etc.
    };

    print("🟢 Post data: ${postData}");

    // Configura el cliente dio para hacer la solicitud HTTP
    Dio dio = Dio();
    String token = dotenv.env['ACCESS_TOKEN'].toString();
    dio.options.headers["x-access-token"] = token;
    final String ruta = "${dotenv.env['BASE_URL_BACK']}/posts";

    try {
      final response = await dio.post(
        ruta,
        data: postData,
      );
      print("Publicación creada con éxito: ${response.data}");
    } catch (e) {
      print("Error al crear la publicación: $e");
    }
  }

  // Función para obtener el tipo MIME basado en la extensión
  String _getContentType(String extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'mp4':
        return 'video/mp4';
      // Agrega más tipos MIME según los formatos que necesites
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Actualiza la fecha y la hora para mostrarlas en el campo
    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    String formattedTime = selectedTime.format(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:
              const Text('Nueva Publicación', style: TextStyle(fontSize: 20)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.02, horizontal: size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo de Título
                CustomInputField2(
                  hintText: 'Título',
                  labelText: 'Título',
                  controller: titleController,
                ),
                SizedBox(height: size.height * 0.02),

                // Selección de tipo de publicación
                DropdownButtonFormField<int>(
                  value: selectedItem, // Controla el tipo de publicación
                  onChanged: (newValue) {
                    setState(() {
                      selectedItem = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Publicación',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Blog'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('Evento'),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('Encuesta'),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                // Si es una encuesta, permitir escribir una descripción
                if (selectedItem == 3) ...[
                  CustomInputField2(
                    hintText: 'Descripción de la encuesta',
                    labelText: 'Descripción de la encuesta',
                    controller:
                        placeController, // Puedes usar un controller dedicado para esto
                  ),
                ],
                // Sección de imagen
                if (selectedItem != 3) ...[
                  const Text('Seleccionar Imagen', textAlign: TextAlign.start),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: size.height * 0.07,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: _imageFile != null
                              ? FileImage(_imageFile!)
                              : const AssetImage(
                                      'assets/img/Design/bg_select_image.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: size.height * 0.02),
                // Permitir interacción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: interactionType,
                        onChanged: (newValue) {
                          setState(() {
                            interactionType = newValue!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Permitir interacción a',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Cualquier usuario registrado'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Solo verificados'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.02),
                // Selección de ODS
                DropdownButtonFormField<String>(
                  value: selectedOds, // Valor seleccionado
                  onChanged: (newValue) {
                    setState(() {
                      selectedOds = newValue; // Actualiza el valor seleccionado
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Selecciona un ODS',
                    border: OutlineInputBorder(),
                  ),
                  items: odsData.map((ods) {
                    return DropdownMenuItem(
                      value: ods['id'],
                      child: Text(
                        ods['name'] ?? '',
                        overflow: TextOverflow
                            .ellipsis, // Para evitar desbordamientos
                        style: const TextStyle(
                            fontSize: 12), // Ajusta el tamaño del texto
                      ),
                    );
                  }).toList(),
                ),

                // Campos adicionales si es un evento
                if (selectedItem == 2) ...[
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _pickDate,
                        child: SizedBox(
                          width: size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                  height:
                                      4), // Espacio entre la caja y el texto
                              const Text('Fecha', textAlign: TextAlign.start),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.primary),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.date_range,
                                        color: AppTheme
                                            .primary), // Ícono de calendario
                                    SizedBox(
                                        width:
                                            8), // Espacio entre ícono y texto
                                    Text(
                                      formattedDate, // Valor seleccionado
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _pickTime,
                        child: SizedBox(
                          width: size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                  height:
                                      4), // Espacio entre la caja y el texto
                              const Text('Hora', textAlign: TextAlign.start),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.primary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        color:
                                            AppTheme.primary), // Ícono de reloj
                                    SizedBox(
                                        width:
                                            8), // Espacio entre ícono y texto
                                    Text(
                                      formattedTime, // Valor seleccionado
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomInputField2(
                    hintText: 'Lugar',
                    labelText: 'Lugar',
                    controller: placeController,
                  ),
                ],
                // Contenido dinámico según el tipo de publicación
                if (selectedItem == 1 || selectedItem == 2) ...[
                  SizedBox(height: size.height * 0.02),
                  // Botón de Adjuntar Archivos
                  const Text('Adjuntar Archivos', textAlign: TextAlign.start),
                  ElevatedButton.icon(
                    onPressed: _pickAttachments,
                    icon: const Icon(Icons.attach_file),
                    label: const Text("Seleccionar Archivos"),
                  ),
                  SizedBox(height: size.height * 0.02),
                  HtmlEditor(
                    controller: editorHtmlController,
                    htmlEditorOptions: const HtmlEditorOptions(
                        hint: "Escribe aquí...", autoAdjustHeight: true),
                    htmlToolbarOptions: const HtmlToolbarOptions(
                        toolbarType: ToolbarType.nativeGrid,
                        defaultToolbarButtons: [
                          FontButtons(),
                          FontSettingButtons(fontSizeUnit: false),
                          InsertButtons(audio: false, hr: false),
                          ListButtons(listStyles: false),
                          ParagraphButtons(
                              caseConverter: false,
                              lineHeight: false,
                              textDirection: false)
                        ]),
                  ),
                ],
                // Campos adicionales si es una encuesta
                if (selectedItem == 3) ...[
                  SurveyForm(onQuestionsUpdated: _updateQuestions),
                ],

                // Botón de Publicar
                CustomButton1(
                  texto: 'Publicar',
                  icono: Icons.publish,
                  bgFondo: AppTheme.primary,
                  onPressed: _submitPost,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
