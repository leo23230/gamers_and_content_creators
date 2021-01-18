import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/authenticate/authenticate_buttons.dart';
import 'package:gamers_and_content_creators/screens/authenticate/register.dart';
import 'package:gamers_and_content_creators/screens/authenticate/sign_in.dart';
import 'package:gamers_and_content_creators/screens/authenticate/authenticate.dart';

//ignore: must_be_immutable
class ContentManager extends StatefulWidget {
  @override
  _ContentManagerState createState() => _ContentManagerState();
}

class _ContentManagerState extends State<ContentManager> {
  int content = 0;
  void showSignInForm(){
    setState(() => content = 1);
  }
  void showRegisterForm(){
    setState(() => content = 2);
  }
  @override
  Widget build(BuildContext context) {
    switch(content){
      case 0:{
        return AuthenticateButtons(showSignInForm: showSignInForm, showRegisterForm: showRegisterForm);
      }
      break;

      case 1:{
        return SignIn(showSignInForm: showSignInForm, showRegisterForm: showRegisterForm);
      }
      break;

      case 2:{
        return Register(showSignInForm: showSignInForm, showRegisterForm: showRegisterForm);
      }
      break;
    }
  }
}
