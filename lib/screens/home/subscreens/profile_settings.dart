import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/cards/youtube_card.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/settings.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/user_data_form.dart';
import 'package:gamers_and_content_creators/services/upload.dart';
import 'package:gamers_and_content_creators/shared/card_enum.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';
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
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(_selectedImage),
            fit: BoxFit.cover,
          ),
          border: Border.all(width: 4, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
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
        UserData userData = snapshot.data;

        if(snapshot.hasData){

        }
        else{
          if(snapshot.hasError) print(snapshot.error);
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.pink[500],
            actions: <Widget>[
              FlatButton.icon( //Edit
                icon: Icon(Icons.edit, size: 24),
                label: Text(
                  'edit info',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.grey[900],
                  ),
                ),
                onPressed: (() => _showUserDataForm()),
              ),
              FlatButton.icon( //card
                icon: Icon(Icons.ad_units, size: 24),
                label: Text(
                  'manage cards',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.grey[900],
                  ),
                ),
                onPressed: (){Navigator.pushNamed(context, '/card-manager');},
              ),
            ],
          ),
          body:(snapshot.hasData) ? CustomScrollView(
            slivers: <Widget> [
              SliverAppBar(
                expandedHeight: 260.0,
                backgroundColor: Colors.black,
                pinned: false,
                floating: false,
                toolbarHeight: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(userData.profileImagePath == '')getImageWidget()
                      else Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(userData.profileImagePath),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(width: 4, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ],
                  ),
                  titlePadding: EdgeInsets.all(20),
                  stretchModes: [StretchMode.blurBackground],
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
                                // IconButton(
                                //   icon: Icon(
                                //     Icons.ad_units,
                                //     color: Colors.white,
                                //   ),
                                //   onPressed: (){Navigator.pushNamed(context, '/card-manager');},
                                // ),
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
                          color: Colors.black,
                          child: Center(
                            child: SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: PageView(
                                controller: _controller,
                                scrollDirection: Axis.horizontal,
                                children:[
                                  for(int i = 0; i < userData.cards.length; i++)
                                    if(userData.cards[i] == 'Youtube Card') enumToWidget(userData.cards[i], userData.ytChannelId)
                                    else enumToWidget(userData.cards[i]),
                                  // Container(
                                  //   height: cardHeight,
                                  //   width: cardWidth,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.orange,
                                  //     borderRadius: BorderRadius.circular(15),
                                  //     image: DecorationImage(
                                  //       image: AssetImage('assets/Twitch Card.png'),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Container(
                                  //   height: cardHeight,
                                  //   width: cardWidth,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.yellow,
                                  //     borderRadius: BorderRadius.circular(15),
                                  //   ),
                                  // ),
                                  // Container(
                                  //   height: cardHeight,
                                  //   width: cardWidth,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.green,
                                  //     borderRadius: BorderRadius.circular(15),
                                  //   ),
                                  // ),
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
          ) : Loading(),
        );
      }
    );
  }
}