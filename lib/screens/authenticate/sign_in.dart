import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/services/oauth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Colors.grey[800],
      /*appBar: AppBar(
        backgroundColor: Colors.pink[500],
        elevation: 0.0,
        title: Text(
          'Sign In',
          style: GoogleFonts.lato(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      ),*/
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration:BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/his and her setup.jpg',
            ),
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Binxy',
              style: GoogleFonts.pacifico(
                fontSize: 96.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: FlatButton(
                color: Colors.pink[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  side: BorderSide(color: Colors.white, width: 2),
                ),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.lato(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
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
            ),
            SizedBox(height: 30.0),
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: FlatButton(
                color: Colors.deepPurpleAccent[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  side: BorderSide(color: Colors.white, width: 2),
                ),
                hoverColor: Colors.white,
                child: Text(
                  'Discord Sign In',
                  style: GoogleFonts.lato(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  String url = _oauth.discordLoginUrl;
                  if(await canLaunch(url)){
                    await(launch(url));
                    dynamic result = await _auth.signInAnon();
                    if(result == null){
                      print('error signing in');
                    } else {
                      print('signed in');
                      print(result.uid);
                    }
                  }
                  else{
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}