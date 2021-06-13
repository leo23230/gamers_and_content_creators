import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/services/user_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final _formKey = GlobalKey<FormState>();

  //values
  //first set preferences with default values
  double _rad = UserPreferences.getMaxRadius() ?? 30;
  RangeValues _ageRange = RangeValues(UserPreferences.getAgeMin() ?? 18, UserPreferences.getAgeMax() ?? 24);

  Future setAgeRange(double min, double max) async{
    await UserPreferences.setAgeMin(min);
    await UserPreferences.setAgeMax(max);
  }

  @override
  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);

    return Form(
      key: _formKey,
        child:Column(
          children: [
            Text(
              'Preferences',
              style: GoogleFonts.lato(
                fontSize: 26,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Distance',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Slider(
                    activeColor: Colors.deepOrange[400],
                    inactiveColor: Colors.deepOrange[100],
                    label:'radius: $_rad miles',
                    max: 500,
                    min: 30,
                    value: (_rad ?? 30),
                    divisions: 47,
                    onChanged: ((val) => setState(() => _rad = val)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Age Range',
                  style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: RangeSlider(
                    activeColor: Colors.deepOrange[400],
                    inactiveColor: Colors.deepOrange[100],
                    labels: RangeLabels(
                      _ageRange.start.toString(),
                      _ageRange.end.toString(),
                    ),
                    max: 65,
                    min: 18,
                    values: _ageRange,
                    divisions: 47,
                    onChanged: ((val) => setState(() => _ageRange = val)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(onPressed: (() {}), child: Text('M',style: GoogleFonts.lato(fontSize: 18, color: Colors.white)), color: Colors.grey[600]),
                FlatButton(onPressed: (() {}), child: Text('W', style: GoogleFonts.lato(fontSize: 18, color: Colors.white)), color: Colors.grey[600]),
                FlatButton(onPressed: (() {}), child: Text('Non-Binary', style: GoogleFonts.lato(fontSize: 18, color: Colors.white)), color: Colors.grey[600])
              ],
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.pink[500],
              child: Text(
                'Update',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: () async{
                await UserPreferences.setMaxRadius(_rad);
                await setAgeRange(_ageRange.start, _ageRange.end);
                await DatabaseService(uid: user.uid).updateUserData(
                    radius: _rad.toInt(),
                );
                //update database eventually
                Navigator.pop(context);
              },
            ),
          ],
        )
    );
  }
}
