import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/ods.model.dart';
import 'package:loja_sostenible/widgets/widgets.dart';

class OdsScreen extends StatefulWidget {

  const OdsScreen({
    super.key, 
    required this.navigatorKey
  });

  final GlobalKey navigatorKey;

  @override
  State<OdsScreen> createState() => _OdsScreenState();
}



class _OdsScreenState extends State<OdsScreen> {

  List<Ods> odsList = [];

  @override
  void initState() {
    super.initState();
    getODS();
  }

  Future<List<Ods>> getODS() async{
    final response = await Dio().get("${dotenv.env['BASE_URL_BACK']}/ods");
    final jsonBody = response.data;
    final odsListJson = jsonBody['ods'] as List;
    odsList = odsListJson.map((e) => Ods.fromJson(e)).toList();
  
    return odsList;
  }




  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Navigator(
      key: widget.key,
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            return SingleChildScrollView(
                child: Column(
                  children: [
                    Image(
                      image: const NetworkImage('https://noticias.utpl.edu.ec/sites/default/files/styles/noticia_detalle_banner/public/multimedia/loja-sostenible-2030.jpg'),
                      fit: BoxFit.cover,
                      height: size.height * 0.2,
                    ),
                    FutureBuilder(
                      future: getODS(), 
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              padding: EdgeInsets.only(bottom: size.height * 0.02),
                              height: size.height * 0.742,
                              child: GridView.builder(
                                itemCount: snapshot.data?.length,
                                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,                        
                                ), 
                                itemBuilder: (context, index){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomCardOds(
                                      ods: odsList[index]
                                    ),
                                  );
                                }
                              ),
                            ),
                          );
                        }else{
                          return const Center(child: CircularProgressIndicator());
                        }
                      }
                    ),
                  ]
                ), 
              );
          }
        );
      }
    );
  }
}
