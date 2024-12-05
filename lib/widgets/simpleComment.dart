import 'package:flutter/material.dart';
import 'package:loja_sostenible/models/comment.model.dart';
import 'package:loja_sostenible/providers/comments.service.dart';
import 'package:loja_sostenible/theme/app_theme.dart';
import 'package:loja_sostenible/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';


class SimpleCommment extends StatefulWidget {

  final CommentsP comment;

  const SimpleCommment({
    super.key, 
    required this.comment
  });

  @override
  State<SimpleCommment> createState() => _SimpleCommmentState();
}

class _SimpleCommmentState extends State<SimpleCommment> {


  TextEditingController replyController = TextEditingController();
  TextEditingController replyController2 = TextEditingController();

  bool responseComment = false;
  
  List<bool> _responseReplies = [];

  @override
  void initState() {
    super.initState();
    _responseReplies = List.generate(widget.comment.replies.length, (index) => false);
  }


  @override
  Widget build(BuildContext context) {

    final CommentsProvider commentsProvider = Provider.of<CommentsProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: commentsProvider.getComments(idPublication: widget.comment.postId),
      builder: ((context, snapshot) {      
        if(snapshot.hasData){
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(31, 167, 165, 165),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: EdgeInsets.all(size.height*0.01),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CircleAvatar(
                          radius: 23,
                          child: Image(
                            image: NetworkImage( widget.comment.user.profileImage )
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.comment.user.firstname} ${widget.comment.user.lastname}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.comment.content),
                          SizedBox(
                            height: 25,
                            child: TextButton(
                              onPressed: () async{
                                setState(() {                            
                                  responseComment = !responseComment;
                                });
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
                              ), 
                              child: Text( 
                                responseComment == true ? 'Cancelar' : 'Responder', 
                                style: TextStyle(color: responseComment == true ? Colors.red :AppTheme.primary)),                    
                            ),
                          ),  
                          Builder(builder: (context){
                            if( responseComment == true){
                              return Row(
                                children: [
                                  Container(
                                    height: 25,
                                    width: size.width * 0.6,
                                    child: CustomInputField(
                                      controller: replyController,
                                      hintText: 'Reponder...',
                                    )
                                  ),
                                  IconButton(
                                    onPressed: () async{
                                      if(replyController.text.length > 2){
                                        await commentsProvider.postReply(
                                          idComment: widget.comment.id,
                                          content: replyController.text,
                                          idPublication: widget.comment.postId
                                        );
                                        FocusScope.of(context).unfocus();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Comentario Agregado con exito'),
                                            duration: Duration(seconds: 2),
                                          )
                                        );            
                                        responseComment = false;
                                        replyController.clear();
                                      }
                                    }, 
                                    icon: const Icon(Icons.send_and_archive_rounded, color: Colors.white,),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(AppTheme.primary)
                                    ),
                                    tooltip: 'Comentar',
                                  )
                                ],
                              );  
                            }
                            return Container();
                          })
                        ]    
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.15, top: size.height * 0.015),
                    child: Consumer(
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            SizedBox(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(widget.comment.replies.length, (index) {
                                    Reply reply = widget.comment.replies[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: CircleAvatar(
                                              radius: 17,
                                              child: Image(
                                                image: NetworkImage( reply.user.profileImage )
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("${reply.user.firstname} ${reply.user.lastname}", style: const TextStyle(fontWeight: FontWeight.bold),),
                                                    if(reply.nameUserReplied.isNotEmpty)
                                                    const Icon(Icons.arrow_right),
                                                    Text( reply.nameUserReplied, style: const TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                Text(reply.content),
                                                SizedBox(
                                                  height: 25,
                                                  child: TextButton(
                                                    onPressed: ()async{
                                                      setState(() {
                                                        _responseReplies[index] = !_responseReplies[index];
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
                                                    ), 
                                                    child: Text( 
                                                      _responseReplies[index] == true ? 'Cancelar' : 'Reponder', 
                                                      style: TextStyle(color: _responseReplies[index] == true ? Colors.red : AppTheme.primary)
                                                    ),                    
                                                  ),
                                                ),  
                                                Builder(builder: (context){
                                                  if( _responseReplies[index] ){
                                                  return Row(
                                                    children: [
                                                      Container(
                                                        height: 25,
                                                        width: size.width * 0.5,
                                                        child: CustomInputField(
                                                          controller: replyController2,
                                                          hintText: 'Reponder...',
                                                        )
                                                      ),
                                                      IconButton(
                                                        onPressed: () async{
                                                          if(replyController2.text.length > 2){
                                                            await commentsProvider.postReply(
                                                              idComment: widget.comment.replies[index].id,
                                                              content: replyController2.text,
                                                              idPublication: widget.comment.postId
                                                            );
                                                            FocusScope.of(context).unfocus();
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(
                                                                content: Text('Comentario Agregado con exito'),
                                                                duration: Duration(seconds: 2),
                                                              )
                                                            );
                                                            replyController2.clear();  
                                                            setState(() async{
                                                              _responseReplies[index] = !_responseReplies[index];
                                                            });
                                                            
                                                          }
                                                        }, 
                                                        icon: const Icon(Icons.send_and_archive_rounded, color: Colors.white,),
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all(AppTheme.primary)
                                                        ),
                                                        tooltip: 'Comentar',
                                                      )
                                                    ],
                                                  );  
                                                }
                                                return Container();
                                                })  
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              )
                            )
                          ]
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          );
        }else{
          return const Center(child: CircularProgressIndicator()); 
        }

      }) 
      
    );
  }
}