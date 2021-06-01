import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeCard extends StatefulWidget {
  @override
  _AnimeCardState createState() => _AnimeCardState();
}

class _AnimeCardState extends State<AnimeCard> {

  final double cardHeight = 480;
  final double cardWidth = 360;
  final List animeList = ['assets/CowboyBebop.png', 'assets/DeathNote.jpg', 'assets/Hunter.png', 'assets/OnePiece.jpg', 'assets/SpiritedAway.jpg'];
  final List animeNames =['Cowboy Bebop', 'DeathNote', 'Hunter x Hunter', 'One Piece', 'Spirited Away'];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.grey[800],
            Colors.grey[900],
          ],
        ),
        border: Border.all(color: Colors.white, width: 4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Favorite Anime',
            style: GoogleFonts.lato(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
          //SizedBox(height: 0),
          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(),
              //margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20,10,20,0),
                child: GridView.count(
                  primary:false,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                  children: [
                    for(final anime in animeList)
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(anime),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                            child: Text(
                              animeNames[animeList.indexOf(anime)],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
