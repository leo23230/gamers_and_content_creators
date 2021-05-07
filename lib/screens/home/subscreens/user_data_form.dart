import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:provider/provider.dart';
import 'package:age/age.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamers_and_content_creators/services/google_auth.dart';
import 'package:http/http.dart' as http;

class UserDataForm extends StatefulWidget {
  @override
  _UserDataFormState createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {
  User user;
  http.Response response;

  String channelId;

  Future click() async { //sets channelId to the String returned from signInWithGoogle method
    channelId = await signInWithGoogle();
    print(channelId);
  }

  bool loading = false;
  File _selectedImage;

  //form keys
  final _formKey = GlobalKey<FormState>();
  final _dobFormKey = GlobalKey<FormState>();


  // text field state
  String _name;
  String _age;
  int _monthNumber;
  int _day;
  int _year;
  String _location = '';
  String error = '';

  // Arrays For Drop Down Button Form Fields
  List <String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  List <int> days = [];
  int numberOfDays = 0; // For auto populating for loop
  List <int> years = [];

  //Functions for Date of Birth
  bool isThirtyOne () {
    if(_monthNumber == 1 || _monthNumber == 3 || _monthNumber == 5||
        _monthNumber == 7 || _monthNumber == 8 || _monthNumber == 10 ||
        _monthNumber == 12){
      return true;
    }
    else{
      return false;
    }
  }
  bool isFebruary () {
    if(_monthNumber == 2){
      return true;
    }
    else{
      return false;
    }
  }

  int monthCalculation(val){
    _monthNumber = val;
    if(isThirtyOne()) numberOfDays = 31;
    else if (isFebruary()) numberOfDays = 28;
    else numberOfDays = 30;
    days = [];
    for(int i = 0; i < numberOfDays; i++){
      days.add(i+1);
    }
    return _monthNumber;
  }

  //get Image function
  getImage(ImageSource source) async{
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.pink[500],
            toolbarTitle: "Crop Image",
            statusBarColor: Colors.pink[500],
            backgroundColor: Colors.grey[900],
          )
      );
      this.setState((){_selectedImage = croppedImage;});
    }
  }

  //GoogleSignIn

  Widget googleLoginButton(){
    return OutlineButton(
      onPressed: this.click,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      splashColor: Colors.grey,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0,10,0,10),
        child: Row(
          mainAxisSize: MainAxisSize.min, //as small as possible
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Image(image:AssetImage('assets/YoutubeLogo.png'), height: 35),
            Padding(padding: EdgeInsets.only(left: 10), child: Text('Connect Youtube', style: TextStyle(color: Colors.grey, fontSize: 24)))
          ],
        ),
      )
    );
  }

  //Main Build Function
  @override
  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data;
          // _day = userData.day;
          // _monthNumber = userData.month;
          // _year = userData.year;

          if(userData.month!= 0){
            monthCalculation(_monthNumber);
          }

          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    'Name',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 8.0),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      initialValue: userData.name,
                      decoration: textInputDecoration,
                      validator: (val) => val.isEmpty ? 'Enter a name' : null,
                      onChanged: (val) {
                        if(val.length > 1) {
                          setState(() => _name = val);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Date of Birth',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                  Form(
                    key: _dobFormKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: DropdownButtonFormField(
                            value: userData.month,
                            items: months.map((month){
                              return DropdownMenuItem(
                                value: months.indexOf(month) + 1,
                                child: Text(month, style: GoogleFonts.lato(fontSize: 16)),
                              );
                            }).toList(),
                            decoration: textInputDecoration,
                            validator: (val) => val == null ? 'Enter a month' : null,
                            onTap: ((){_dobFormKey.currentState.reset();}),
                            onChanged: (val) => setState(() {
                              _monthNumber = val;
                              if(isThirtyOne()) numberOfDays = 31;
                              else if (isFebruary()) numberOfDays = 28;
                              else numberOfDays = 30;
                              days = [];
                              for(int i = 0; i < numberOfDays; i++){
                                days.add(i+1);
                              }
                              return _monthNumber;
                            }),
                          ),
                        ),
                        SizedBox(width: 4),
                        SizedBox( //Day Drop Down
                          width: 75,
                          child: DropdownButtonFormField(
                            value: userData.day,
                            items: days.map((day){
                              return DropdownMenuItem(
                                value: day,
                                child: Text(day.toString(), style: GoogleFonts.lato(fontSize: 16)),
                              );
                            }).toList(),
                            decoration: textInputDecoration,
                            validator: (val) => val == null ? 'Enter #' : null,
                            onChanged: (val) => setState(() {_day = val;}),
                          ),
                        ),
                        SizedBox(width: 4),
                        SizedBox( //Year Text Form Field
                          width: 125,
                          child: TextFormField(
                            initialValue: userData.year.toString(),
                            decoration: textInputDecoration,
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              var now = new DateTime.now();
                              if(now.year - int.parse(val) > 124 || int.parse(val) > now.year){
                                return 'Enter a valid year';
                              }
                              else return null;
                            },
                            onChanged: (val) {setState(() => _year = int.parse(val));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),

                  // //Google sign-in//
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: googleLoginButton(),
                  // ),
                  //
                  // RaisedButton(
                  //   color: Colors.pink[500],
                  //   child: Text(
                  //     'Disconnect Youtube',
                  //     style: GoogleFonts.lato(
                  //       fontSize: 18,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   onPressed: (){signOutOfGoogle();},
                  // ),

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
                      _name == null ? _name = userData.name : null;
                      _day == null ? _day = userData.day : null;
                      _monthNumber == null ? _monthNumber = userData.day : null;
                      _year == null ? _year = userData.year : null;
                      _age == null ? _age = userData.age : null;
                      _location == null ? _location = userData.location : null;
                      if(_formKey.currentState.validate() && _dobFormKey.currentState.validate()){
                        var now = new DateTime.now();
                        var dob = new DateTime(_year,_monthNumber, _day);
                        _age = Age.dateDifference(fromDate: dob, toDate: now, includeToDate:false).years.toString();
                        print(_age);
                        if(int.parse(_age) >= 18 && int.parse(_age) <= 124){
                          await DatabaseService(uid: user.uid).updateUserData(
                            _name ?? userData.name,
                            _age ?? userData.age,
                            _location ?? userData.location,
                            _monthNumber ?? userData.month,
                            _day ?? userData.day,
                            _year ?? userData.year,
                              //We don't need to update these values here
                            userData.profileImagePath,
                            userData.backgroundImagePath,
                            userData.cards,
                            channelId ?? userData.ytChannelId,
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
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