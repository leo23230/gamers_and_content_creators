import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/profile_widget.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _currentIndex = 0;
  final List <Widget> tabs = [
    Text('Profile'),
    Text('Home'),
    Text('Matches')
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title: tabs[_currentIndex],
          backgroundColor: Colors.pink[500],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.deepOrange[400],
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.grey[800],
          onTap: (index) {
            setState((){
              _currentIndex = index;
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
      ),
    );
  }
}