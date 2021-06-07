import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/conversation.dart';
import 'package:gamers_and_content_creators/models/message_model.dart';
import 'package:gamers_and_content_creators/services/messaging_service.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final String otherUserName;
  final String otherUserUrl;
  final String conversationId;
  Chat({this.otherUserName, this.otherUserUrl, this.conversationId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _controller = TextEditingController();
  String message = '';
  String otherUserName;
  String otherUserUrl;
  String conversationId;

  @override

  Widget build(BuildContext context) {
    //for easy reading
    otherUserName = widget.otherUserName;
    otherUserUrl = widget.otherUserUrl;
    conversationId = widget.conversationId;

    return StreamProvider.value(
      value: MessagingService(conversationId: conversationId).messages,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar:AppBar(
          title: Text(
            otherUserName, //will eventually be replaced by person's name
            style: GoogleFonts.lato(fontSize: 24),
          ),
          backgroundColor: Colors.pink[500],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Messages(),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8),
              child: Row(
                children:[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: false,
                      enableSuggestions: true,
                      decoration: textInputDecoration.copyWith(
                        labelText: 'Message',
                      ),
                      onChanged: (val) => setState((){message = val;})
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(final message in Provider.of<List<Message>>(context))
          Expanded(
            child: Container(
                color: Colors.white,
                child: Text(
                  message.message,
                  style: GoogleFonts.lato(fontSize: 14, color: Colors.black),
                )
            ),
          ),
      ],
    );//Messages;
  }
}
