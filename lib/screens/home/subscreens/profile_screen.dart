import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/profile.dart';
import 'package:gamers_and_content_creators/shared/card_enum.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:gamers_and_content_creators/shared/profile_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/screens/home/cards/stats_card.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;
  ProfileScreen({this.profile});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _controller = PageController(
    initialPage: 0,
  );
  int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Color(0xff0a0010),
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: NetworkImage(widget.profile.backgroundImagePath),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 60, 0, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ProfileImage(
                          size: 100,
                          borderWidth: 2,
                          url: widget.profile.profileImagePath,
                          isButton: false,
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.profile.name,
                              style: GoogleFonts.lato(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Music Producer',
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: Colors.orange,
                              ),
                            ),
                            // Text(
                            //     widget.profile.location[0],
                            //   style: GoogleFonts.lato(
                            //     fontSize: 20,
                            //     color: Colors.orange,
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 480,
                    width: 360,
                    child: PageView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      children:[
                        StatsCard(),
                        for(int i = 0; i < widget.profile.cards.length; i++) //This creates a physical card for ever item in the cards list
                          enumToWidget( //this is where we pass in all of the data for all of the cards
                            widget.profile.cards[i],
                            channelId: widget.profile.ytChannelId,
                            bioTitle: widget.profile.bioTitle,
                            bioBody: widget.profile.bioBody,
                            instagramPics: widget.profile.instagramPics,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 360,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for(double i = 0; i < widget.profile.cards.length; i++)
                          Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: (i == _currentPage) ? Colors.grey[700] : Colors.grey[850],
                                shape: BoxShape.circle
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              width: 40,
              margin: EdgeInsets.fromLTRB(8, 4, 0, 4),
              decoration: ShapeDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                shape: CircleBorder(),
              ),
              child: BackButton(
                color: Colors.white,
                //onPressed:(){},
              ),
            ),
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Container(
                      width: 40,
                      margin: EdgeInsets.fromLTRB(8, 4, 8, 0),
                      decoration: ShapeDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: (){},
                      ),
                    ),
                    Container(
                      width: 40,
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                      decoration: ShapeDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.group,
                          color: Colors.white,
                        ),
                        onPressed: (){},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed_sharp),
            title: Text('Feed'),
          ),
        ],
      ),
    );
  }
}
