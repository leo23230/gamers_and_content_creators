import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/profile.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/profile_screen.dart';

class ProfileImage extends StatelessWidget {
  final url;
  double size;
  double borderWidth;
  bool isButton;
  Profile profile;

  ProfileImage({this.url, this.size, this.borderWidth, this.isButton, this.profile});

  @override
  Widget build(BuildContext context) {
    if(this.size == null) this.size = 180;
    if(isButton == null) this.isButton = false; //because a profile is required
    return FlatButton(
      onPressed: this.isButton ? (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(profile: this.profile,)),
        );
      } : null,
      padding: EdgeInsets.zero,
      minWidth: 0,
      child: Container(
        width: this.size,
        height: this.size,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(this.url),
            fit: BoxFit.cover,
          ),
          border: Border.all(width: (borderWidth!=null) ? borderWidth : 4, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
    );
  }
}
