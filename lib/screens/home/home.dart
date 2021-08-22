import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/profile.dart';
import 'package:gamers_and_content_creators/screens/home/swipe.dart';
import 'package:gamers_and_content_creators/screens/home/matches.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  final AuthService _auth = AuthService();
  int _currentIndex = 1;
  final List <String> tabs = [
    'Profile',
    'Home',
    'Matches',
  ];
  final List <Widget> screens = [
    Profile(),
    Swipe(),
    Matches(),
  ];

  final _controller = PageController(
    initialPage: 1,
  );

  @override
  bool get wantKeepAlive => true;
  @override

  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);
    super.build(context);
    return StreamProvider.value(
      value: DatabaseService(uid: user.uid).userData,
      child:  Scaffold(
        backgroundColor: Color(0xff0a0010),
        // appBar: AppBar(
        //   title: Text(
        //       tabs[_currentIndex],
        //       style: GoogleFonts.lato(
        //         fontSize: 24,
        //         color: Colors.white,
        //       )
        //   ),
        //   backgroundColor: Colors.pink[500], //Color(0xffFB4F47),
        //   elevation: 0.0,
        //   actions: <Widget>[
        //     FlatButton.icon(
        //       icon: Icon(Icons.person, size: 24),
        //       label: Text(
        //         'logout',
        //         style: GoogleFonts.lato(
        //           fontSize: 18,
        //           color: Colors.grey[900],
        //         ),
        //       ),
        //       onPressed: () async {
        //         await _auth.signOut();
        //       },
        //     ),
        //   ],
        // ),
        body: SafeArea(
          child: PageView(
            controller: _controller,
            children:[
              Profile(),
              Swipe(),
              Matches()
            ],
            onPageChanged: (index){
              setState((){
                _currentIndex = index;
              });
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.white, width: 0.25)),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Color(0xfffba220),
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.black,
            selectedFontSize: 15,
            unselectedFontSize: 12,
            selectedIconTheme: IconThemeData(
              size: 26,
            ),
            unselectedIconTheme: IconThemeData(
              size: 18,
            ),
            onTap: (index) {
              setState((){
                _currentIndex = index;
                _controller.animateToPage(_currentIndex, duration: Duration(milliseconds: 400), curve: Curves.easeOut);
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                title: Text('Threads'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//