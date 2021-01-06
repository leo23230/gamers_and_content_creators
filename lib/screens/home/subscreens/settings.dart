import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final _formKey = GlobalKey<FormState>();

  //values
  double _rad = 70;
  double _age = 30;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
        child:Column(
          children: [
            Text(
              'Settings',
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
                    label:'radius: $_rad',
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
                  child: Slider(
                    activeColor: Colors.deepOrange[400],
                    inactiveColor: Colors.deepOrange[100],
                    label:'radius: $_age',
                    max: 500,
                    min: 30,
                    value: (_age ?? 30),
                    divisions: 47,
                    onChanged: ((val) => setState(() => _age = val)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(onPressed: (() {}), child: Text('men'), color: Colors.grey[600]),
                FlatButton(onPressed: (() {}), child: Text('women'), color: Colors.grey[600]),
                FlatButton(onPressed: (() {}), child: Text('all'), color: Colors.grey[600])
              ],
            ),
          ],
        )
    );
  }
}
