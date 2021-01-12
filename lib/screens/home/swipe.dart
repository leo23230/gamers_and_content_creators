import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/screens/home/home.dart';
class Swipe extends StatefulWidget {
  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> with AutomaticKeepAliveClientMixin<Swipe> {
  final double cardHeight = 560;
  final double cardWidth = 420;
  final _controller = PageController(
    initialPage: 0,
  );

  //FakeData//
  final List <String> pics = [
    'assets/Bridget.png',
    'assets/Chives.png',
    'assets/Jack Circle.png',
    'assets/MooShu.png',
    'assets/Noah.png',
    'assets/Shu.png'
  ];
  final List <String> setups = [
    'assets/clean pc setup.jpg',
    'assets/pc setup 2.jpg',
    'assets/pc setup 3.jpg',
    'assets/pc setup 4.jpg',
    'assets/pc setup 5.jpg',
    'assets/pc setup 6.jpg'
  ];
  final List <String> names = [
    'Bridget',
    'Chives',
    'Jack',
    'MooShu',
    'Noah',
    'Shu'
  ];
  final List <String> ages = [
    '27',
    '31',
    '26',
    '64',
    '24',
    '32'
  ];
  int personIndex = 0;
  ////

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage(setups[personIndex]),
          colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget> [
          SliverAppBar(
            expandedHeight: 310.0,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0),
            pinned: false,
            floating: false,
            toolbarHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(pics[personIndex]),
              title: ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children:[
                  SizedBox(
                    width:50,
                    height:50,
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () {
                        if(personIndex < 5){
                          personIndex += 1;
                          setState((){});
                          print(personIndex);
                        }
                      else{
                        personIndex = 0;
                        setState((){});
                        print(personIndex);
                        }
                      },
                      child: Icon(Icons.remove),
                      backgroundColor: Colors.pink[500],
                    ),
                  ),
                  //SizedBox(width:50),
                  SizedBox(
                    width:50,
                    height:50,
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: (){
                        if(personIndex < 5){
                          personIndex += 1;
                          setState((){});
                          print(personIndex);
                        }
                        else{
                          personIndex = 0;
                          setState((){});
                          print(personIndex);
                        }
                      },
                      child: Icon(Icons.favorite),
                      backgroundColor: Colors.pink[500],
                    ),
                  ),
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
                              names[personIndex],
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            //SizedBox(width: 190),
                            Text(
                              'Age: ' + ages[personIndex],
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
    );
  }
}
