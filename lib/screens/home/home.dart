import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/profile.dart';
import 'package:gamers_and_content_creators/screens/home/swipe.dart';
import 'package:gamers_and_content_creators/screens/home/matches.dart';
import 'package:google_fonts/google_fonts.dart';

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
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          tabs[_currentIndex],
          style: GoogleFonts.lato(
          fontSize: 24,
          color: Colors.white,
          )
        ),
        backgroundColor: Colors.pink[500],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, size: 24),
            label: Text(
              'logout',
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Colors.grey[900],
              ),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: PageView(
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange[400],
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.grey[900],
        selectedFontSize: 15,
        unselectedFontSize: 12,
        selectedIconTheme: IconThemeData(
          size: 28,
        ),
        unselectedIconTheme: IconThemeData(
          size: 20,
        ),
        onTap: (index) {
          setState((){
            _currentIndex = index;
            _controller.animateToPage(_currentIndex, duration: Duration(milliseconds: 200), curve: Curves.linear);
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
            title: Text('Matches'),
          ),
        ],
      ),
    );
  }
}