import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/settings.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/user_data_form.dart';
import 'package:gamers_and_content_creators/services/upload.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  //card variables
  final double cardHeight = 480;
  final double cardWidth = 360;

  //page controller
  final _controller = PageController(
    initialPage: 0,
  );

  //image variables
  File _selectedImage;

  //image get function
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

  Widget getImageWidget(){
    if(_selectedImage != null){
      return CircleAvatar(
        backgroundImage: FileImage(_selectedImage),
      );
    }
    else{
      return Image.asset(
        "assets/Dante.png",
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    //final userProfile = Provider.of<UserData>(context);

    void _showUserDataForm(){
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          color: Colors.grey[800],
          child: UserDataForm(),
        );
      });
    }

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,//listening to a stream from DBService
      builder: (context, snapshot) { //data down the stream is referred to as a snapshot
        // if(snapshot.hasData){
        //
        // }
        // else{
        //
        // }
        UserData userData = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink[500],
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.edit, size: 24),
                label: Text(
                  'edit',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.grey[900],
                  ),
                ),
                onPressed: (() => _showUserDataForm()),
              ),
            ],
          ),
          body:Container(
            color: Colors.grey[850],
            child: CustomScrollView(
              slivers: <Widget> [
                SliverAppBar(
                  expandedHeight: 340.0,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                  pinned: false,
                  floating: false,
                  toolbarHeight: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: getImageWidget(),
                    title: ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children:[
                        SizedBox(
                          width:50,
                          height:50,
                          child: FloatingActionButton(
                            heroTag: "cameraButton",
                            onPressed: () {getImage(ImageSource.camera);},
                            child: Icon(Icons.camera),
                            backgroundColor: Colors.pink[500],
                          ),
                        ),
                        Uploader(file: _selectedImage),
                        //SizedBox(width:50),
                        SizedBox(
                          width:50,
                          height:50,
                          child: FloatingActionButton(
                            heroTag: "galleryButton",
                            onPressed: (){getImage(ImageSource.gallery);},
                            child: Icon(Icons.image),
                            backgroundColor: Colors.pink[500],
                          ),
                        ),
                      ],
                    ),
                    titlePadding: EdgeInsets.all(20),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                    return Container(
                      child: Column(
                        children:<Widget> [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],//Color.fromRGBO(100,0,150,1),
                              boxShadow: [
                                BoxShadow(
                                  color:Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(
                                    0,
                                    -5,
                                  ),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //SizedBox(width: 30),
                                  Text(
                                    userData.name,
                                    style: GoogleFonts.lato(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                  //SizedBox(width: 190),
                                  Text(
                                    'Age: ' + userData.age,
                                    style: GoogleFonts.lato(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 550,
                            color: Colors.grey[800],
                            child: Center(
                              child: SizedBox(
                                height: cardHeight,
                                width: cardWidth,
                                child: PageView(
                                  controller: _controller,
                                  scrollDirection: Axis.horizontal,
                                  children:[
                                    Container(
                                      height: cardHeight,
                                      width: cardWidth,
                                      decoration: BoxDecoration(
                                        //color: Colors.red,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage('assets/Youtube Card.png'),
                                        ),

                                      ),
                                    ),
                                    Container(
                                      height: cardHeight,
                                      width: cardWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage('assets/Twitch Card.png'),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: cardHeight,
                                      width: cardWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    Container(
                                      height: cardHeight,
                                      width: cardWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height:40,
                            color: Colors.grey[900],//Color.fromRGBO(100,0,150,1),
                          ),
                        ],
                      ),
                    );
                  },
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}