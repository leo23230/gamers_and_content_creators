import'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:gamers_and_content_creators/shared/keys.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/youtube', // Youtube scope
    //'https://www.googleapis.com/youtube/v3/channels',
  ],
);

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  // final AuthCredential credential = GoogleAuthProvider.credential(
  //     idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

  //Not Needed
  // final UserCredential authResult = await _auth.signInWithCredential(credential);
  // final User user = authResult.user;
  //
  // //maker sure sign in leads to getting authenticated in firebase
  // assert(!user.isAnonymous);
  // assert(await user.getIdToken() != null);
  //
  // final User currentUser = _auth.currentUser;
  // assert(currentUser.uid == user.uid);

  // Map<String, String> parameters = {
  //   'part': 'snippet, contentDetails, statistics',
  //   'id': channelId,
  //   'key': YT_API_KEY,
  // };

  print("URI");
  Map<String, String> parameters = {
    'mine': 'true',
  };
  Uri uri = Uri.https(
    'www.googleapis.com',
    '/youtube/v3/channels',
    parameters,
  );

  String accessToken = googleSignInAuthentication.accessToken;
  print("Access Token: $accessToken");

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + accessToken,
  };

  http.Response response = await http.get(uri, headers: headers);
  if (response.statusCode == 200) {
    //Map<String, dynamic> data = json.decode(response.body)['items'][0];
    String jsonDataString = response.body.toString();
    var _data = json.decode(jsonDataString);
    print(_data.toString());
    Map<String, dynamic> items = json.decode(response.body)['items'][0];
    List itemsList = items.values.toList();
    String channelId = itemsList[2];
    //print(channelId);
    return channelId;
  }
  else {
    throw json.decode(response.body)['error']['message'];
  }
  //return user;

}

Future signOutOfGoogle() async{
  googleSignIn.disconnect();
}