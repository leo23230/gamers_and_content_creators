import 'package:flutter/material.dart';

class BlankProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(width: 4, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(90)),
        ),
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 120,
        ),
      );
    }
  }
