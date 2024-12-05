import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/forms.model.dart';
import 'package:loja_sostenible/models/publications.model.dart';
import 'package:loja_sostenible/models/user.model.dart';
import 'package:loja_sostenible/providers/user.service.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.navigatorKey});

  final GlobalKey navigatorKey;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> postsList = [];
  List<Forms> formsList = [];
  User? userActive;

  int postsIterator = 1;
  int formsIterator = 1;
  bool isLoadingPosts = false;
  bool isLoadingForms = false;
  bool hasMorePosts = true;
  bool hasMoreForms = true;
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    getPosts(postsIterator).then((newPosts) {
      setState(() {
        postsList = newPosts;
      });
    });
    getForms(formsIterator).then((newForms) {
      setState(() {
        formsList = newForms;
      });
    });
    getUser().then((value) => setState(() {
          userActive = value;
        }));
  }

  Future<void> loadMorePosts() async {
    print("loadMorePosts");
    if (isLoadingPosts || !hasMorePosts) return;

    setState(() {
      isLoadingPosts = true;
      postsIterator += 1;
    });

    final newPosts = await getPosts(postsIterator);

    // Verifica si la cantidad de posts recibidos es menor al límite esperado
    if (newPosts.isEmpty || newPosts.length == 0) {
      setState(() {
        hasMorePosts = false; // No hay más publicaciones
      });
    }

    setState(() {
      postsList.addAll(newPosts);
      isLoadingPosts = false;
    });
  }

  Future<void> loadMoreForms() async {
    print("loadMoreForms");
    if (isLoadingForms || !hasMoreForms) return;

    setState(() {
      isLoadingForms = true;
      formsIterator += 1;
    });

    final newForms = await getForms(formsIterator);
    // Verifica si la cantidad de posts recibidos es menor al límite esperado
    if (newForms.isEmpty || newForms.length == 0) {
      setState(() {
        hasMoreForms = false; // No hay más publicaciones
      });
    }

    setState(() {
      formsList.addAll(newForms);
      isLoadingForms = false;
    });
  }

  Future<List<Post>> getPosts(int iterator) async {
    print("getPosts ${iterator}");
    final dio = Dio();

    // TODO: cambiar debe ser dinamico el token
    final Map<String, String> headers = {
      'x-access-token': dotenv.env['ACCESS_TOKEN'].toString()
    };

    dio.options.headers = headers;

    final response = await dio
        .get("${dotenv.env['BASE_URL_BACK']}/posts?iterator=$iterator");
    final jsonBody = response.data;
    final postsListJson = jsonBody['posts'] as List;
    final newPostsList = postsListJson.map((e) => Post.fromJson(e)).toList();

    return newPostsList;
  }

  Future<List<Forms>> getForms(int iterator) async {
    print("getForms ${iterator}");
    final dio = Dio();

    // TODO: cambiar debe ser dinamico el token
    final Map<String, String> headers = {
      'x-access-token': dotenv.env['ACCESS_TOKEN'].toString()
    };

    dio.options.headers = headers;

    final response = await dio
        .get("${dotenv.env['BASE_URL_BACK']}/forms?iterator=$iterator");
    final jsonBody = response.data;
    print("getForms data ${jsonBody}");
    final formsListJson = jsonBody['forms'] as List;
    final newFormsList = formsListJson.map((e) => Forms.fromJson(e)).toList();

    return newFormsList;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: AppTheme.whiteLS,
                appBar: AppBar(
                  backgroundColor: AppTheme.whiteLS,
                  title: FutureBuilder(
                    future: getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AppBarFeed(user: userActive);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  bottom: const TabBar(
                      labelColor: AppTheme.primary,
                      indicatorColor: AppTheme.primary,
                      tabs: [
                        Tab(text: "Publicaciones"),
                        Tab(text: "Encuestas")
                      ]),
                  elevation: 5,
                ),
                body: TabBarView(children: [
                  Center(
                    child: SingleChildScrollView(
                      child: FutureBuilder(
                        future: Future.value(
                            postsList), // Utilizamos la lista de posts ya cargada
                        builder: (context, snapshot) {
                          if (postsList.isNotEmpty) {
                            // Usamos postsList en lugar de snapshot.data
                            return Container(
                              height: size.height * 0.78,
                              child: RefreshIndicator(
                                color: AppTheme.primary,
                                onRefresh: () {
                                  return Future.delayed(
                                      const Duration(seconds: 2));
                                },
                                child: SafeArea(
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .padding
                                            .bottom),
                                    itemCount: postsList.length +
                                        (isLoadingPosts
                                            ? 1
                                            : 0), // Mostrar el loader al final si estamos cargando
                                    itemBuilder: (context, index) {
                                      if (index == postsList.length) {
                                        return Center(
                                            child:
                                                CircularProgressIndicator()); // Indicador de carga
                                      }

                                      if (index == postsList.length - 1 &&
                                          !isLoadingPosts &&
                                          hasMorePosts) {
                                        // Diferimos la llamada a loadMorePosts usando addPostFrameCallback
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          loadMorePosts();
                                        });
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: CustomCardFeed(
                                            post: postsList[index]),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: FutureBuilder(
                          future: Future.value((formsList)),
                          builder: (context, snapshot) {
                            if (formsList.isNotEmpty) {
                              return Container(
                                height: size.height * 0.8,
                                child: RefreshIndicator(
                                  color: AppTheme.primary,
                                  onRefresh: () {
                                    return Future.delayed(
                                        const Duration(seconds: 2));
                                  },
                                  child: SafeArea(
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                      itemCount: formsList.length +
                                          (isLoadingForms ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (index == formsList.length) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (index == formsList.length - 1 &&
                                            !isLoadingForms &&
                                            hasMoreForms) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            loadMoreForms();
                                          });
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: CustomCardFeed2(
                                              form: formsList[index]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ),
                  ),
                ]),
              ),
            );
          },
        );
      },
    );
  }
}
