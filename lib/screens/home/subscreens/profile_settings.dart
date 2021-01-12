import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  final double cardHeight = 480;
  final double cardWidth = 360;
  final _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[500],
      ),
      body:Container(
        color: Colors.grey[850],
        child: CustomScrollView(
          slivers: <Widget> [
            SliverAppBar(
              expandedHeight: 340.0,
              backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              pinned: false,
              floating: false,
              toolbarHeight: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset('assets/Dante.png'),
                title: ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children:[
                  ],
                ),
                titlePadding: EdgeInsets.all(20),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                return Container(
                  child: Column(
                    children:<Widget> [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],//Color.fromRGBO(100,0,150,1),
                          boxShadow: [
                            BoxShadow(
                              color:Colors.black,
                              blurRadius: 10,
                              offset: Offset(
                                0,
                                -5,
                              ),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //SizedBox(width: 30),
                              Text(
                                'Dante',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              //SizedBox(width: 190),
                              Text(
                                'Age: 24',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 550,
                        color: Colors.grey[800],
                        child: Center(
                          child: SizedBox(
                            height: cardHeight,
                            width: cardWidth,
                            child: PageView(
                              controller: _controller,
                              scrollDirection: Axis.horizontal,
                              children:[
                                Container(
                                  height: cardHeight,
                                  width: cardWidth,
                                  decoration: BoxDecoration(
                                    //color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: AssetImage('assets/Youtube Card.png'),
                                    ),

                                  ),
                                ),
                                Container(
                                  height: cardHeight,
                                  width: cardWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: AssetImage('assets/Twitch Card.png'),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: cardHeight,
                                  width: cardWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                Container(
                                  height: cardHeight,
                                  width: cardWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height:40,
                        color: Colors.grey[900],//Color.fromRGBO(100,0,150,1),
                      ),
                    ],
                  ),
                );
              },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
