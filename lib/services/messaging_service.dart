import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamers_and_content_creators/models/message_model.dart';

class MessagingService {

  final myUid;
  final otherUid;
  MessagingService({this.myUid, this.otherUid}); //both parameters optional

  final CollectionReference conversationsCollection = FirebaseFirestore.instance.collection('conversations');

  String getConversationId (String user, String user1){
    //compareTo returns negative value if user is ordered before user1
    //check to see if the value is negative, if it is return user-user1, else return user1-user
    //this ensures that the ConversationId between these two users is the same every time
    //so we are only storing each message ONCE under that specific conversation
    if (user.compareTo(user1) < 0) return user+'-'+user1;
    else return user1+'-'+user;
  }

  //This function is called when a match is made
  Future createConversation() async{
    final String conversationId = getConversationId(myUid, otherUid);
    conversationsCollection.doc(conversationId).set({
      'conversationId': conversationId, //so we can find the specific conversation (if needed)
      'users' : [myUid, otherUid], //so we can find all of the conversations that the user is involved in
    });
  }

  //Upload Message Method//
  Future uploadMessage(String myUid, String message) async{
    //get a reference to the user's messages collection
    final String conversationId = getConversationId(myUid, otherUid);
    final messagesRef = FirebaseFirestore.instance.collection('conversations/$conversationId/messages');

    //upload the message to that user's
    await messagesRef.doc(DateTime.now().toString()).set({
      'sentBy': myUid,
      'createdAt': DateTime.now(),
      'message': message,
    });
  }

  // List<Message> _messagesFromSnapshot (QueryDocumentSnapshot snapshot) {
  //
  // }
  //
  // Future<List<Message>> getMessages () async{
  //   QuerySnapshot messagesSnapshot = await messagesCollection.get(uid);
  //   List<QueryDocumentSnapshot> messageDocs = messagesSnapshot.docs;
  //
  //   messageDocs.map(_messagesFromSnapshot);
  // }
  //
  // Stream<List<Message>> get messages{
  //   return messagesCollection.order
  // }

}