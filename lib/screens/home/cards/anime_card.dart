import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeCard extends StatefulWidget {
  @override
  _AnimeCardState createState() => _AnimeCardState();
}

class _AnimeCardState extends State<AnimeCard> {

  final double cardHeight = 480;
  final double cardWidth = 360;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.grey[800],
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
        ],
      ),
    );
  }
}
