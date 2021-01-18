import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:provider/provider.dart';

class UserDataForm extends StatefulWidget {
  @override
  _UserDataFormState createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String _name = '';
  String _age = '';
  String _location = '';
  String error = '';

  @override
  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    //validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => _name = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.age,
                    decoration: textInputDecoration,
                    //validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                    onChanged: (val) {
                      if(val.length > 1){
                        setState(() => _age = val);
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
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
                      await DatabaseService(uid: user.uid).updateUserData(
                        _name ?? userData.name,
                        _age ?? userData.age,
                        _location ?? userData.location,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                  SizedBox(height: 12.0),
                ],
              ),
            ),
          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}
