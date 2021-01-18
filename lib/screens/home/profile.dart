import 'package:flutter/material.dart';
import 'subscreens/settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/models/profile.dart';
import 'package:provider/provider.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/screens/home/home.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/profile_settings.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    void _showSettings(){
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          color: Colors.grey[800],
          child: Settings(),
        );
      });
    }

    return Column(
        children:[
          SizedBox(
            height:120,
            child: Card(
              color: Color.fromRGBO(255, 255, 255, 0.2),
              child: ListTile(
                visualDensity: VisualDensity(vertical: 4),
                leading: Image.asset('assets/Dante.png', scale: 0.5),
                // title: Text(
                //   'Profile Settings',
                //   style: GoogleFonts.lato(
                //     fontSize: 24,
                //     color: Colors.white,
                //   ),
                // ),
                subtitle: Text(
                  'Profile Settings',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                onTap: (){Navigator.pushNamed(context, '/profile-settings');},//Navigator.pushNamed(context, '/profile-settings');
              ),
            ),
          ),
          Card(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            child: ListTile(
              leading: Icon(
                Icons.settings,
                size:50.0,
              ),
              title: Text(
                'App Settings',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.grey[900],
                ),
              ),
              subtitle: Text(
                  'Change Location Settings',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey[900],
                ),
              ),
              onTap: (() => _showSettings()),
            ),
          ),
          Card(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            child: ListTile(
              leading: Icon(
                Icons.money,
                size:50.0,
              ),
              title: Text(
                'Free Points!',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.grey[900],
                ),
              ),
              subtitle: Text(
                'Tap to earn free points!',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey[900],
                ),
              ),
              onTap: ((){}),
            ),
          ),
          Card(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            child: ListTile(
              leading: Icon(
                Icons.monetization_on,
                size:50.0,
              ),
              title: Text(
                'Deals!',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.grey[900],
                ),
              ),
              subtitle: Text(
                'Get great deals for using our app!',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey[900],
                ),
              ),
              onTap: ((){}),
            ),
          ),
      ],
    );
  }
}
