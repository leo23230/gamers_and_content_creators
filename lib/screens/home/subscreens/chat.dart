import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/conversation.dart';
import 'package:gamers_and_content_creators/models/message_model.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/messaging_service.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  void sendMessage(String userId) async {
    FocusScope.of(context).unfocus();
    await MessagingService(myUid: userId, conversationId: conversationId).uploadMessage(message);
    _controller.clear();
  }

  @override

  Widget build(BuildContext context) {
    //for easy reading
    otherUserName = widget.otherUserName;
    otherUserUrl = widget.otherUserUrl;
    conversationId = widget.conversationId;

    UserModel user = Provider.of<UserModel>(context);

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
            Expanded(child: Messages()),
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
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.send,
                    ),
                    onPressed:(){(message.trim().isEmpty) ? null : sendMessage(user.uid);}
                  ),
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

    List<Message> messages = Provider.of<List<Message>>(context);
    UserModel user = Provider.of<UserModel>(context);

    return messages.isEmpty ? Text('Start chatting!', style: GoogleFonts.lato(fontSize: 24, color: Colors.grey[400])) :
    ListView.builder(
      physics: BouncingScrollPhysics(),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        DateTime dateTime = message.createdAt.toDate().toLocal();
        DateTime lastDateTime = (index > 0) ? messages[index - 1].createdAt.toDate().toLocal() : null;
        
        if(lastDateTime != null) {
          return
            (dateTime.day < lastDateTime.day)
                ? DateSeparator(
                    dateTime: dateTime,
                    message: message.message,
                    isMe: message.sentBy == user.uid,
                    time: message.createdAt) // < because its in reverse
                : MessageWidget(
                    message: message.message,
                    isMe: message.sentBy == user.uid,
                    time: message.createdAt,
                  );
        }
        else{
          return MessageWidget(
            message: message.message,
            isMe: message.sentBy == user.uid,
            time: message.createdAt,
          );
        }

      }
    );
    // return Column(
    //   children: [
    //     for(final message in Provider.of<List<Message>>(context))
    //       Container(
    //         margin: EdgeInsets.all(8),
    //         color: Colors.white,
    //         child: Text(
    //           message.message,
    //           style: GoogleFonts.lato(fontSize: 18, color: Colors.black),
    //         ),
    //       ),
    //   ],
    // );//Messages;
  }
}
class MessageWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final dynamic time;
  MessageWidget({this.message, this.isMe, this.time});

  @override
  Widget build(BuildContext context) {
    final Radius radius = Radius.circular(10);
    final borderRadius = BorderRadius.all(radius);
    DateTime dateTime = time.toDate().toLocal();
    // String hour = (dateTime.hour > 12) ? (dateTime.hour - 12).toString() : dateTime.hour.toString();
    // String minute = (dateTime.minute < 10) ? '0' + dateTime.minute.toString() : dateTime.minute.toString();
    // String amPm = (dateTime.hour > 11 && dateTime.hour != 24) ? 'pm' : 'am';
    String timeSent = DateFormat.jm().format(dateTime);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[500] : Colors.pink[500],
                borderRadius: isMe ?
                    borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                    : borderRadius.subtract(BorderRadius.only(bottomLeft: radius))
              ),
              child: Text(message, style: GoogleFonts.lato(fontSize: 16, color: Colors.white),),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                timeSent,
                style: GoogleFonts.lato(
                    color: Colors.grey[700],
                ),
                textAlign: isMe ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DateSeparator extends StatelessWidget {
  final DateTime dateTime;
  final String message;
  final bool isMe;
  final dynamic time;
  DateSeparator({this.dateTime, this.message, this.isMe, this.time});
  @override
  Widget build(BuildContext context) {
    //print( DateFormat.yMd(dateTime).toString());
    String date =  DateFormat.yMMMEd().format(dateTime);
    print(date);
    return Column(
      children: [
        MessageWidget(
          message: message,
          isMe: isMe,
          time: time,
        ),
        Center(
          child: Text(
            date,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          )
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
