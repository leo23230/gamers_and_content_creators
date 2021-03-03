import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:age/age.dart';

class Register extends StatefulWidget {

  final Function showRegisterForm;
  final Function showSignInForm;
  Register({this.showRegisterForm, this.showSignInForm});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _dobFormKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  String _name = '';
  String _age = '';
  int _monthNumber = 0;
  int _day = 0;
  int _year = 0;
  String _location = '';

  // Arrays For Drop Down Button Form Fields
  List <String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  List <int> days = [];
  int numberOfDays = 0; // For auto populating for loop
  List <int> years = [];
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

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 8.0),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
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
                          items: months.map((month){
                            return DropdownMenuItem(
                              value: months.indexOf(month) + 1,
                              child: Text(month, style: GoogleFonts.lato(fontSize: 16)),
                            );
                          }).toList(),
                          decoration: textInputDecoration,
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
                      SizedBox(
                        width: 75,
                        child: DropdownButtonFormField(
                          items: days.map((day){
                            return DropdownMenuItem(
                              value: day,
                              child: Text(day.toString(), style: GoogleFonts.lato(fontSize: 16)),
                            );
                          }).toList(),
                          decoration: textInputDecoration,
                          onChanged: (val) => setState(() {_day = val;}),
                        ),
                      ),
                      SizedBox(width: 4),
                      SizedBox( //Year Form
                        width: 125,
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Year'),
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            var now = new DateTime.now();
                            if(val.isEmpty){
                              return 'Enter a year';
                            }
                            else if(now.year - int.parse(val) > 124 || int.parse(val) > now.year){
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
                SizedBox(height: 15.0),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                    color: Colors.pink[500],
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate() && _dobFormKey.currentState.validate()){
                        setState(() => loading = true);
                        //Calculate Age From DOB
                        var now = new DateTime.now();
                        var dob = new DateTime.utc(_year,_monthNumber, _day);
                        _age = Age.dateDifference(fromDate: dob, toDate: now, includeToDate:false).years.toString();
                        print(_age);
                        //submit information
                        if(int.parse(_age) >= 18 && int.parse(_age) <= 124){
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password, _name,_age,_location,_monthNumber,_day,_year);
                          if(result == null) {
                            setState(() {
                              error = 'Please supply a valid email';
                              loading = false;
                            });
                          }
                        }
                        else{
                          error = 'You are not the right age to register for Binxy';
                          loading = false;
                        }
                      }
                    }
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                SizedBox(height: 12.0),
                FlatButton(
                  color: Color.fromRGBO(0, 0, 0, 0),
                  padding: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: Colors.white, width: 2),
                  ),
                  hoverColor: Colors.white,
                  child: Text(
                    'Have an account? Click Here To Sign In!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    widget.showSignInForm();
                  },
                ),
              ],
            ),
          ),
      );
    }
}