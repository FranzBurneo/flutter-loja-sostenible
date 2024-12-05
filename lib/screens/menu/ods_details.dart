import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/ods.model.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:loja_sostenible/widgets/widgets.dart';

class OdsDetailsScreen extends StatefulWidget {
  final Ods ods;

  const OdsDetailsScreen({super.key, required this.ods});

  @override
  State<OdsDetailsScreen> createState() => _OdsDetailsScreenState();
}

class _OdsDetailsScreenState extends State<OdsDetailsScreen> {
  List<Ods> odsList = [];

  Future<List<Ods>> getODS() async {
    final response = await Dio().get("${dotenv.env['BASE_URL_BACK']}/ods");
    final jsonBody = response.data;
    final odsListJson = jsonBody['ods'] as List;

    final filteresOdsListJson =
        odsListJson.where((ods) => ods['id'] != widget.ods.id).toList();

    setState(() {
      odsList = filteresOdsListJson.map((e) => Ods.fromJson(e)).toList();
    });

    return odsList;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Objetivo ${widget.ods.number}",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        backgroundColor: Color(int.parse('0xff${widget.ods.color}')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.whiteLS),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: const NetworkImage(
                          'https://forums.synfig.org/uploads/default/original/2X/3/320a629e5c20a8f67d6378c5273cda8a9e2ff0bc.gif'),
                      image: NetworkImage(widget.ods.cardImage),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Center(
                          child: Text(widget.ods.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(
                                      int.parse('0xff${widget.ods.color}')))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.ods.description,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black45),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(widget.ods.largeDescription)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              height: size.height * 0.15,
              child: FutureBuilder(
                  future: getODS(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: odsList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CardsSliderOds(ods: odsList[index]);
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
