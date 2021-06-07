import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final url;
  ProfileImage({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(this.url),
          fit: BoxFit.cover,
        ),
        border: Border.all(width: 4, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
    );
  }
}
