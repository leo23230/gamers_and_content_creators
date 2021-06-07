import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/conversation.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/chat.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/services/messaging_service.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';
import 'package:gamers_and_content_creators/shared/profile_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConversationsList extends StatefulWidget {
  @override
  _ConversationsListState createState() => _ConversationsListState();
}

class _ConversationsListState extends State<ConversationsList> {
  Conversation conversation;
  List<dynamic> otherUserData;
  String otherUserName;
  String otherUserId;
  String otherUserUrl;
  String conversationId;
  List<String> userNameList = List<String>();
  List<String> userUrlList = List<String>();
  List<String> userConversationList = List<String>();
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);
    final conversations = Provider.of<List<Conversation>>(context);
    return (conversations != null) ? ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        conversation = conversations[index];
        var users = conversation.users;
        users.remove(user.uid); //remove my uid from the users list
        otherUserId = users[0]; //set the other uid
        otherUserData = conversation.userDataMap[otherUserId];
        otherUserName = otherUserData[0]; //uses other UserId as key for map, the value is an array containing name, then profilepicURL
        otherUserUrl = otherUserData[1];
        conversationId = conversation.id;
        if(!userNameList.contains(otherUserName))userNameList.add(otherUserName);
        if(!userUrlList.contains(otherUserUrl))userUrlList.add(otherUserUrl);
        if(!userConversationList.contains(conversationId))userConversationList.add(conversationId);
        // print('userNameList $userNameList');
        // print('conversationId $conversationId');
        // print('userConversationList $userConversationList');
        return Card(
          color: Colors.grey[850],
          child: ListTile(
            visualDensity: VisualDensity(vertical: 4),
            onTap:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chat(
                  otherUserName: userNameList[index],
                  otherUserUrl: userUrlList[index],
                  conversationId: userConversationList[index],
                )),
              );
            },
            leading: FlatButton(
              onPressed: (){},
              child: SizedBox(width: 60, height: 60, child: ProfileImage(url: otherUserUrl))
            ),
            title: Text(
              otherUserName,
              style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
            ),
            trailing: Icon(
              Icons.arrow_right,
              size: 50,
            ),
          ),
        );
      }
  ) : Container();
  }
}
