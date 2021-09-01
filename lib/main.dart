import 'package:gamers_and_content_creators/screens/home/subscreens/card_manager.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/followers.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/map.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/user_data_form.dart';
import 'package:gamers_and_content_creators/screens/wrapper.dart';
import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/services/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:gamers_and_content_creators/services/dynamic_links.dart';
import 'package:gamers_and_content_creators/screens/home/home.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/profile_settings.dart';
// Add async/await and 2 lines of code to the main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await UserPreferences.init();

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

  //locks device orientation
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black
    ));
  }

  Widget build(BuildContext context) {
    handleStartupLogic();
    return MultiProvider(
      providers: [
        StreamProvider<UserModel>.value(
          value: AuthService().user,
        ),
        /*StreamProvider<UserData>.value(
          value: DatabaseService().userData,
        )*/
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/':(context) => Wrapper(),
          '/home': (context) => Home(),
          '/profile-settings': (context) => ProfileSettings(),
          '/card-manager' : (context) => CardManager(),
          '/user-info' : (context) => UserDataForm(),
          '/map': (context) => MapWidget(),
          '/followers': (context) => Followers(),
        },
        initialRoute: '/',
        theme: ThemeData(
          accentColor: Colors.orange,
        ),
      ),
      //home: Wrapper(),
    );
  }
}