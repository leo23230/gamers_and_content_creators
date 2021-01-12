import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> with AutomaticKeepAliveClientMixin<Matches>{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,20,0,0),
      child: Column(
        children:[
          CarouselSlider(
            options: CarouselOptions(
              height:400,
              initialPage:0,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              enableInfiniteScroll: false,
              viewportFraction: 0.6,
            ),
            items:<Widget>[
              Container(
                width:300,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SizedBox(height: 125, width: 125, child: Image.asset('assets/Noah.png')),
                      SizedBox(height: 20),
                      Text('Noah', style: GoogleFonts.lato(fontSize: 24, color: Colors.white)),
                      SizedBox(height:20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age: 24', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500]), textAlign: TextAlign.left),
                          Text('Discord: Noah357', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
                        ],
                      ),
                      SizedBox(height:20.0),
                      Text('Gamer', style: GoogleFonts.lato(fontSize: 22, color: Colors.red)),
                      //SizedBox(height: 10),
                      //Text('Discord: noah2118', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Container(
                width:240,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SizedBox(height: 125, width: 125, child: Image.asset('assets/MooShu.png')),
                      SizedBox(height: 20),
                      Text('MooShu', style: GoogleFonts.lato(fontSize: 24, color: Colors.white)),
                      SizedBox(height:20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age: 64', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
                          Text('Discord: shoeman1', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
                        ],
                      ),
                      SizedBox(height:20.0),
                      Text('Vlogger', style: GoogleFonts.lato(fontSize: 22, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Container(
                width:240,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SizedBox(height: 125, width: 125, child: Image.asset('assets/Chives.png')),
                      SizedBox(height: 20),
                      Text('Chives', style: GoogleFonts.lato(fontSize: 24, color: Colors.white)),
                      SizedBox(height:20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age: 31', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
                          Text('Discord: sp1c3', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
                        ],
                      ),
                      SizedBox(height:20.0),
                      Text('Content Creator', style: GoogleFonts.lato(fontSize: 22, color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
