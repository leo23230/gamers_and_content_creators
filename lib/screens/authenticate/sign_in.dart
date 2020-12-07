import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/services/oauth.dart';
import 'package:url_launcher/url_launcher.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final Oauth _oauth = Oauth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        title: Text('Sign in'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('sign in anon'),
              onPressed: () async {
                dynamic result = await _auth.signInAnon();
                if(result == null){
                  print('error signing in');
                } else {
                  print('signed in');
                  print(result.uid);
                }
              },
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.purple[300],
              child: Text('sign in with discord'),
              onPressed: () async {
                String url = _oauth.discordLoginUrl;
                if(await canLaunch(url)){
                  await(launch(url));
                }
                else{
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}