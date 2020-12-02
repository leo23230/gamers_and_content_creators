import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/screens/authenticate/authenticate.dart';
import 'package:gamers_and_content_creators/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }

  }
}