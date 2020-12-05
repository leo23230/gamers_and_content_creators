import 'package:gamers_and_content_creators/screens/wrapper.dart';
import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:gamers_and_content_creators/services/dynamic_links.dart';

// Add async/await and 2 lines of code to the main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isCreatingLink = false;
  String _linkMessage;
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  Future handleStartupLogic() async{
    await _dynamicLinkService.handleDynamicLinks();
  }

  @override

  Widget build(BuildContext context) {
    handleStartupLogic();
    return StreamProvider<UserModel>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }

}