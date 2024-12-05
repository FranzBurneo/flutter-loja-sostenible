import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loja_sostenible/models/user.model.dart';

// ignore: must_be_immutable
class AppBarFeed extends StatelessWidget {

  final User? user;

  TextEditingController searchController = TextEditingController(text: '');

  AppBarFeed({
    super.key, 
    this.user,
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TapRegion(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user?.avatarImage ?? dotenv.env['IMAGE_NOT_FOUND']! )
              ),
              onTapInside: (event ){
                print('Hiciste click');
                print(event);
              } ,
            ),
            SizedBox(
              width: size.width * 0.8,
              height: 40,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    contentPadding: EdgeInsets.only(top: 0)
                  )
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}