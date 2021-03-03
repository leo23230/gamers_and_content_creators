import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:provider/provider.dart';

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key:key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://gamers-and-content-creators.appspot.com');

  UploadTask _uploadTask;

  //set the file path to userid-profile_pic
  //copy the file path into the user's firestore document
  //start the upload process COMPLETE
  void _startUpload(String uid, String name, String age, String location, int month, int day, int year, String backgroundImagePath) async {
    String filePath = 'images/$uid-profile-image.jpg';

    await DatabaseService(uid: uid).updateUserData(
        name,
        age,
        location,
        month,
        day,
        year,
        filePath,
        backgroundImagePath,
    );

    //This starts the upload
    setState((){
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);

    var progress;
    if (_uploadTask != null) {
      return StreamBuilder <TaskSnapshot>(
          stream: _uploadTask.snapshotEvents,
          builder: (context, snapshot) {
            _uploadTask.snapshotEvents.listen((snapshot) {
              progress = snapshot.totalBytes / snapshot.bytesTransferred;
              print(snapshot.totalBytes / snapshot.bytesTransferred);
            });
            if (progress == 1.0) {
              return Text('Upload Complete', style: TextStyle(fontSize: 14));
            }
            else {
              return Text('Upload Complete', style: TextStyle(fontSize: 14));
            }
          });
    }
    else {
      return StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          //listening to a stream from DBService
          builder: (context,
              snapshot) { //data down the stream is referred to as a snapshot
            UserData userData = snapshot.data;

            return FlatButton.icon(
              label: Text('Upload', style: TextStyle(color: Colors.pink[500])),
              icon: Icon(Icons.cloud_upload, color: Colors.pink[500]),
              //color: Colors.pink[500],
              onPressed: () {
                _startUpload(
                    user.uid,
                    userData.name,
                    userData.age,
                    userData.location,
                    userData.month,
                    userData.day,
                    userData.year,
                    userData.location
                );
              },
            );
          });
    }
  }
}
