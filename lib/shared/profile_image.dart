import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final url;
  final borderWidth;
  ProfileImage({this.url, this.borderWidth});

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
        border: Border.all(width: (borderWidth!=null) ? borderWidth : 4, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
    );
  }
}
