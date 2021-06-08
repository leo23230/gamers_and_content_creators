import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamers_and_content_creators/models/conversation.dart';
import 'package:gamers_and_content_creators/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/user.dart';

class MessagingService {

  final myUid;
  final otherUid;
  final myName;
  final myUrl;
  final otherName;
  final otherUrl;
  final conversationId;
  MessagingService({this.myUid, this.otherUid, this.myName, this.myUrl, this.otherName, this.otherUrl, this.conversationId}); //both parameters optional

  final CollectionReference conversationsCollection = FirebaseFirestore.instance.collection('conversations');
  List<Conversation>conversationsList = List<Conversation>();

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
      'createdAt' : DateTime.now(),
      'userDataMap' : {myUid : [myName, myUrl], otherUid: [otherName, otherUrl]},
    });
  }

  //Upload Message Method//
  Future uploadMessage(String message) async{
    //get a reference to the user's messages collection
    final messagesRef = FirebaseFirestore.instance.collection('conversations/$conversationId/messages');

    //upload the message to that user's
    await messagesRef.doc(DateTime.now().toString()).set({
      'sentBy': myUid,
      'createdAt': DateTime.now(),
      'message': message,
    });
  }

  List<Conversation> _conversationsFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return Conversation(
        id: doc.data()['conversationId'] ?? '',
        users: doc.data()['users'] ?? [],
        createdAt: doc.data()['createdAt'] ?? '',
        userDataMap: doc.data()['userDataMap'] ?? {},
      );
    }).toList();
  }

  List<Message> _messagesFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Message(
        sentBy: doc.data()['sentBy'] ?? '',
        createdAt: doc.data()['createdAt'] ?? '',
        message: doc.data()['message'] ?? '',
      );
    }).toList();
  }

  // Future<List<Message>> getMessages () async{
  //   final String conversationId = getConversationId(myUid, otherUid);
  //   final messagesRef = FirebaseFirestore.instance.collection('conversations/$conversationId/messages');
  //
  //   //Take query based on the timestamp and turn it into a list of docs
  //   Query messagesQuery = messagesRef.orderBy('createdAt');
  //   QuerySnapshot messagesSnapshot = await messagesQuery.get();
  //   List<QueryDocumentSnapshot> messageDocs = messagesSnapshot.docs;
  //
  //   messageDocs.map(_messagesFromSnapshot);
  // }

  Stream<List<Conversation>> get conversations{
    return FirebaseFirestore.instance
    .collection('conversations')
    .where("users", arrayContains: myUid)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map(_conversationsFromSnapshot);
  }
  Stream<List<Message>> get messages{
    return FirebaseFirestore.instance
    .collection('conversations/$conversationId/messages')
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map(_messagesFromSnapshot);
  }
  //
  // Stream<List<Message>> get messages{
  //   return messagesCollection.order
  // }

}