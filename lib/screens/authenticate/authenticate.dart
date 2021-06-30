import 'package:gamers_and_content_creators/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/authenticate/register.dart';
import 'package:gamers_and_content_creators/screens/authenticate/content_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //int content = 0;
  //bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration:BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/Twine BG.jpg',
            ),
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
            fit: BoxFit.fitWidth,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Twine Logo v1.png',
            ),
            // Text(
            //   'Duwō',
            //   style: GoogleFonts.montserrat(
            //     fontSize: 96.0,
            //     color: Colors.white,
            //   ),
            // ),
            // Text(
            //     'Content creators connect',
            //     style: GoogleFonts.montserrat(
            //       fontSize: 24.0,
            //       color: Colors.white,
            //     )
            // ),
            ContentManager(),
          ],
        ),
      ),
    );
  }
}