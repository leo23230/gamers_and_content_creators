import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/shared/card_enum.dart';
import 'package:provider/provider.dart';
import 'package:gamers_and_content_creators/shared/card_enum.dart';

class PictureUploader {
  final String uid;
  final File file;
  final String fileName;

  PictureUploader({this.uid,this.file, this.fileName});

  UploadTask _uploadTask;
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://gamers-and-content-creators.appspot.com');

  Future<String> startUpload() async {

    String fileName = this.fileName;
    String filePath = 'images/$uid-$fileName';
    String url;

    //This starts the upload
    _uploadTask = _storage.ref().child(filePath).putFile(this.file);

    await _uploadTask.whenComplete(()async {url = await getDownloadUrl(filePath);});

    return url;
  }

  Future<String> getDownloadUrl(String imagePath) async{
    print('upload complete');

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.ref().child(imagePath);
    String imageUrl = await imageRef.getDownloadURL();

    return imageUrl;
  }

}

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
  Future _startUpload(dynamic uid) async {

    String filePath = 'images/$uid-profile-image.jpg';

    //This starts the upload
    setState((){
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }



  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);

    //Download profile image
    Future getDownloadUrl(String imagePath) async{
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference imageRef = storage.ref().child(imagePath);
      String imageUrl = await imageRef.getDownloadURL();
      print(imageUrl);
      await DatabaseService(uid: user.uid).updateUserData(
        profileImagePath: imageUrl,
      );
    }

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
              var uid = user.uid;
              getDownloadUrl('images/$uid-profile-image.jpg');
              return Text('Upload Complete', style: TextStyle(fontSize: 14));
            }
            else {
              return Text('Uploading...', style: TextStyle(fontSize: 14));
            }
          });
    }
    else {
      return FlatButton.icon(
        label: Text('Upload', style: TextStyle(color: Colors.pink[500])),
        icon: Icon(Icons.cloud_upload, color: Colors.pink[500]),
        //color: Colors.pink[500],
        onPressed: () {
          _startUpload(user.uid);
        },
      );
    }
  }
}
