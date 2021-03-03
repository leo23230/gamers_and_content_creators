import 'package:gamers_and_content_creators/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function showRegisterForm;
  final Function showSignInForm;
  SignIn({this.showRegisterForm, this.showSignInForm});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
            SizedBox(
              width: 250,
              child: TextFormField(
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
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
                  'Sign In',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        error = 'Could not sign in with those credentials';
                        loading = false;
                      });
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
                'Not signed up? Click Here To Register!',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                widget.showRegisterForm();
              },
            ),
          ],
        ),
      ),
    );
  }
}