import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class InstagramCard extends StatefulWidget {
  final List<dynamic> pics;

  InstagramCard({this.pics});

  @override
  _InstagramCardState createState() => _InstagramCardState();
}

class _InstagramCardState extends State<InstagramCard> {
  final double cardHeight = 480;
  final double cardWidth = 360;

  final _controller = PageController(
    initialPage: 0,
  );
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.pink[900],
            //Colors.orange,
            Colors.pink[600],
          ],
        ),
        //border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(cardRoundness),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset('assets/ScaledInstagramLogo.png', scale: 0.1),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(cardRoundness),
                  topRight: Radius.circular(cardRoundness),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(5,10,5,10),
                child: PageView(
                  controller: _controller,
                  children:[
                    PictureGridWidget(pics: widget.pics),
                    PictureScrollWidget(pics: widget.pics),
                  ],
                  onPageChanged: (index){
                    setState((){
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
          //SizedBox(height: 10),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Color(0xfffba220),
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.black,
            selectedFontSize: 15,
            unselectedFontSize: 12,
            selectedIconTheme: IconThemeData(
              size: 22,
            ),
            unselectedIconTheme: IconThemeData(
              size: 18,
            ),
            onTap: (index) {
              setState((){
                _currentIndex = index;
                _controller.animateToPage(_currentIndex, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_on),
                title: Text('Gallery View'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward),
                title: Text('Scroll View'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PictureGridWidget extends StatelessWidget {
  final pics;
  PictureGridWidget({this.pics});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Scrollbar(
        radius: Radius.circular(10),
        child: GridView.count(
          //controller: _controller,
          primary:false,
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 1,
          children: [
            for(final pic in this.pics)
              Container(
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(cardRoundness/2),
                  image: DecorationImage(
                    image: NetworkImage(pic),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PictureScrollWidget extends StatelessWidget {

  final pics;
  PictureScrollWidget({this.pics});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      radius: Radius.circular(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListView(
          children: [
            for(final pic in this.pics)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.network(pic),
              )
          ],
        ),
      ),
    );
  }
}

