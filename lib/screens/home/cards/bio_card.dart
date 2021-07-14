import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BioCard extends StatefulWidget {

  BioCard({this.bioTitle, this.bioBody});
  final String bioTitle;
  final String bioBody;

  @override
  _BioCardState createState() => _BioCardState();
}

class _BioCardState extends State<BioCard> {

  final double cardHeight = 480;
  final double cardWidth = 360;

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
        borderRadius: BorderRadius.circular(cardRoundness),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              (widget.bioTitle != null) ? widget.bioTitle : 'Bio',
              style: GoogleFonts.lato(
                fontSize: 40,
                color: Colors.white,
              ),
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
                borderRadius: BorderRadius.circular(cardRoundness),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Linkify(
                    onOpen: _onOpen,
                    text: (widget.bioBody != null) ? widget.bioBody :'No bio',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      color: (widget.bioBody != null) ? Colors.white : Colors.grey,
                    )
                ),
                //   (widget.bioBody != null) ? widget.bioBody :'No bio',
                //   style: GoogleFonts.lato(
                //     fontSize: 20,
                //     color: (widget.bioBody != null) ? Colors.white : Colors.grey,
                //   ),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}