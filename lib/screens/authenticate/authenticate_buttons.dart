import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:gamers_and_content_creators/services/oauth.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticateButtons extends StatefulWidget {
  final Function showRegisterForm;
  final Function showSignInForm;
  AuthenticateButtons({this.showRegisterForm, this.showSignInForm});
  @override
  _AuthenticateButtonsState createState() => _AuthenticateButtonsState();
}

class _AuthenticateButtonsState extends State<AuthenticateButtons> {

  final AuthService _auth = AuthService();
  final Oauth _oauth = Oauth();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: 200.0,
            height: 50.0,
            child: FlatButton(
              color: Color.fromRGBO(0,0,0,0),
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
              onPressed: () {widget.showSignInForm();},
            ),
          ),
          SizedBox(height: 30.0),
          // SizedBox(
          //   width: 200.0,
          //   height: 50.0,
          //   child: FlatButton(
          //     color: Colors.deepPurpleAccent[100],
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(24.0),
          //       side: BorderSide(color: Colors.white, width: 2),
          //     ),
          //     hoverColor: Colors.white,
          //     child: Text(
          //       'Discord Sign In',
          //       style: GoogleFonts.lato(
          //         fontSize: 22,
          //         color: Colors.white,
          //       ),
          //     ),
          //     onPressed: () async {
          //       String url = _oauth.discordLoginUrl;
          //       if(await canLaunch(url)){
          //         await(launch(url));
          //         dynamic result = await _auth.signInAnon();
          //         if(result == null){
          //           print('error signing in');
          //         } else {
          //           print('signed in');
          //           print(result.uid);
          //         }
          //       }
          //       else{
          //         throw 'Could not launch $url';
          //       }
          //     },
          //   ),
          // ),
          //SizedBox(height: 30),
          SizedBox(
            width: 200.0,
            height: 50.0,
            child: FlatButton(
              color: Color.fromRGBO(0,0,0,0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(color: Colors.white, width: 2),
              ),
              hoverColor: Colors.white,
              child: Text(
                'Register',
                style: GoogleFonts.lato(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState((){widget.showRegisterForm();});
              },
            ),
          ),
        ],
      ),
    );
  }
}
