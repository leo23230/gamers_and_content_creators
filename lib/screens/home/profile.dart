import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/shared/blank_profile_picture.dart';
import 'package:gamers_and_content_creators/shared/profile_image.dart';
import 'subscreens/settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/models/profile.dart';
import 'package:provider/provider.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/screens/home/home.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/profile_settings.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    void _showSettings(){
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 2.0, color: Colors.white),
              left: BorderSide(width: 2.0, color: Colors.white),
              right: BorderSide(width: 2.0, color: Colors.white),
            ),
            color: Colors.black,
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Settings(),
        );
      });
    }

    return Column(
        children:[
          SizedBox(
            height:110,
            child: Card(
              color: Colors.grey[850],
              child: ListTile(
                visualDensity: VisualDensity(vertical: 4),
                leading: SizedBox(
                    width: 70,
                    height: 70,
                    child:(userData!= null) ? ProfileImage(url: userData.profileImagePath, borderWidth: 3.0) : BlankProfilePicture(),
                ),
                subtitle: Text(
                  'Profile Settings',
                  style: GoogleFonts.lato(
                    fontSize: 26,
                    color: Colors.grey[200],
                  ),
                ),
                onTap: (){Navigator.pushNamed(context, '/profile-settings');},//Navigator.pushNamed(context, '/profile-settings');
              ),
            ),
          ),
          Card(
            color: Colors.grey[850],
            child: ListTile(
              leading: Icon(
                Icons.settings,
                size:50.0,
              ),
              title: Text(
                'Preferences',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.grey[200],
                ),
              ),
              subtitle: Text(
                  'Help us find the right match for you',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
              onTap: (() => _showSettings()),
            ),
          ),
          // Card(
          //   color: Colors.grey[850],
          //   child: ListTile(
          //     leading: Icon(
          //       Icons.money,
          //       size:50.0,
          //     ),
          //     title: Text(
          //       'Free Points!',
          //       style: GoogleFonts.lato(
          //         fontSize: 20,
          //         color: Colors.grey[200],
          //       ),
          //     ),
          //     subtitle: Text(
          //       'Tap to earn free points!',
          //       style: GoogleFonts.lato(
          //         fontSize: 16,
          //         color: Colors.grey[500],
          //       ),
          //     ),
          //     onTap: ((){}),
          //   ),
          // ),
          Card(
            color: Colors.grey[850],
            child: ListTile(
              leading: Icon(
                Icons.monetization_on,
                size:50.0,
              ),
              title: Text(
                'Deals!',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.grey[200],
                ),
              ),
              subtitle: Text(
                'Get great deals for using our app!',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
              onTap: ((){}),
            ),
          ),



      ],
    );
  }
}
