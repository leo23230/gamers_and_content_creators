import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsCard extends StatefulWidget {
  @override
  _StatsCardState createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.grey[900],
            Color.fromRGBO(20, 20, 20, 1),
          ],
        ),
        //border: Border.all(color: Colors.white, width: 0),
        borderRadius: BorderRadius.circular(cardRoundness),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(),
              //margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                //border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(cardRoundness),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        onPressed: (){Navigator.pushNamed(context, '/followers');},
                        child: Column(
                          children: [
                            Text(
                              '40',
                              style: GoogleFonts.lato(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Followers',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     Text(
                      //       '62',
                      //       style: GoogleFonts.lato(
                      //         fontSize: 32,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(4.0),
                      //       child: Text(
                      //         'Following',
                      //         style: GoogleFonts.lato(
                      //           fontSize: 24,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  Divider(
                    height: 12,
                    thickness: 0.5,
                    color: Colors.white,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Column(
                    children: [
                      Text(
                        '8',
                        style: GoogleFonts.lato(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Collaborators',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 12,
                    thickness: 0.5,
                    color: Colors.white,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Column(
                    children: [
                      Text(
                        '12',
                        style: GoogleFonts.lato(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Projects Completed',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 12,
                    thickness: 0.5,
                    color: Colors.white,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for(int i = 0; i < 5; i++)
                          Icon(
                            Icons.star,
                            size: 32,
                            color: Colors.orange[500],
                          ),
                        Text(
                          '(4.8)',
                          style: GoogleFonts.lato(fontSize: 28, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
