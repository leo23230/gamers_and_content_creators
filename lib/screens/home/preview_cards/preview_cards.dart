import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/services/google_auth.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class YoutubePreviewCard extends StatefulWidget {
  @override
  _YoutubePreviewCardState createState() => _YoutubePreviewCardState();
}

class _YoutubePreviewCardState extends State<YoutubePreviewCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Container(
          height: 160,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(70, 0, 0, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Image.asset('assets/YoutubeLogo.png'),
              ),
            ],
          ),
        ),
      ]
    );
  }
}

class TwitchPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(50, 0, 80, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset('assets/TwitchLogo.png'),
          ),
        ],
      ),
    );
  }
}

class BioPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.grey[800],
            Colors.grey[900],
          ],
        ),
      ),
      child: Center(
        child: Text(
          'Bio',
          style: GoogleFonts.lato(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class AnimePreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.grey[800],
            Colors.grey[900],
          ],
        ),
      ),
      child: Center(
        child: Text(
          'Favorite Anime',
          style: GoogleFonts.lato(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class VideoGamePreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.grey[800],
            Colors.grey[900],
          ],
        ),
      ),
      child: Center(
        child: Text(
          'Favorite Video Games',
          style: GoogleFonts.lato(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AstrologyPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.grey[800],
            Colors.grey[900],
          ],
        ),
      ),
      child: Center(
        child: Text(
          'Astrology',
          style: GoogleFonts.lato(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class OtherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.grey[800],
            Colors.grey[900],
          ],
        ),
      ),
      child: Center(
        child: Text(
          'Other',
          style: GoogleFonts.lato(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SoundcloudPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepOrange[800],
        // gradient: LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        //   colors: [
        //     Colors.grey[800],
        //     Colors.grey[900],
        //   ],
        // ),
      ),
      child: Center(
        child: Text(
          'Soundcloud',
          style: GoogleFonts.lato(fontSize: 22, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class InstagramPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.pink[500],
        // gradient: LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        //   colors: [
        //     Colors.grey[800],
        //     Colors.grey[900],
        //   ],
        // ),
      ),
      child: Center(
        child: Text(
          'Instagram',
          style: GoogleFonts.lato(fontSize: 22, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Future removeCard(String uid, {String name, String age, String location, int month, int day, int year, String pIP, String bIP, List<dynamic> cards, String ytChannelId}) async {
//   UserModel user = Provider.of<UserModel>(context);
//   UserData userData = Provider.of<UserData>(context);
//   setState(){}
// }

List<dynamic> removeCard (List<dynamic> cards, String cardType){
  if (cards.contains(cardType)){
    cards.remove(cardType);
  }
  return cards;
}