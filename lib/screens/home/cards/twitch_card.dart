import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';

class TwitchCard extends StatefulWidget {
  @override
  _TwitchCardState createState() => _TwitchCardState();
}

class _TwitchCardState extends State<TwitchCard> {
  final double cardHeight = 480;
  final double cardWidth = 360;

  @override
  Widget build(BuildContext context) {
    return Container( //TWITCH
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(cardRoundness),
        color: Color.fromRGBO(50, 0, 80, 1),
      ),
      child: Column(
        children: [
          Container(
            child: Image.asset('assets/TwitchLogo.png',scale: 6),
          ),
        ],
      ),
    );
  }
}
