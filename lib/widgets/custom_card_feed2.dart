import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:loja_sostenible/models/forms.model.dart';
import 'package:loja_sostenible/screens/menu/form_details.dart';

class CustomCardFeed2 extends StatelessWidget {
  final Forms? form;

  const CustomCardFeed2({
    super.key,
    required this.form,
  });

  void _navigateToDetailForm(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: FormDetailsScreen(form: form!),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Hero(
      tag: form!.id,
      child: InkWell(
        child: Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(size.height * 0.012),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            radius: 22,
                            child: Image(
                                image:
                                    NetworkImage(form!.userPost.avatarImage)),
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${form!.userPost.firstname} ${form!.userPost.lastname}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18)),
                            Text(
                                "${dateFormat.format(form!.timestamp)} - ${timeFormat.format(form!.timestamp)}",
                                style: const TextStyle(color: Colors.black38))
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_rounded))
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.01),
                child: Text(form!.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Html(
                    data: form!.description,
                    style: {
                      "*": Style(
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: FontSize.medium,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.left,
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
                          color: form!.selectedOds != null
                              ? Color(
                                  int.parse('0xff${form!.selectedOds!.color}'))
                              : Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: form!.selectedOds != null
                            ? Text("ODS ${form!.selectedOds!.number}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white))
                            : const SizedBox(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          _navigateToDetailForm(context);
        },
      ),
    );
  }
}
