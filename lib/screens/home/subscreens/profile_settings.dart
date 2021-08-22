import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/cards/youtube_card.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/settings.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/user_data_form.dart';
import 'package:gamers_and_content_creators/services/upload.dart';
import 'package:gamers_and_content_creators/shared/blank_profile_picture.dart';
import 'package:gamers_and_content_creators/shared/card_enum.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';
import 'package:gamers_and_content_creators/shared/profile_image.dart';
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

  int _currentPage;

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

  ImageProvider getBackgroundImage(String existingBackgroundImagePath){
    if(existingBackgroundImagePath != ''){
      return NetworkImage(existingBackgroundImagePath);
    }
    else{
      return AssetImage('assets/clean pc setup.jpg');
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,//listening to a stream from DBService
      builder: (context, snapshot) { //data down the stream is referred to as a snapshot
        UserData userData = snapshot.data;

        if(snapshot.hasData){
          
        }
        else{
          if(snapshot.hasError) print(snapshot.error);
        }

        return (snapshot.hasData) ? Scaffold(
          body: Stack(
            children: <Widget>[
              SafeArea(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    color: Color(0xff0a0010),
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: NetworkImage(userData.backgroundImagePath),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 60, 0, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ProfileImage(
                              size: 100,
                              borderWidth: 2,
                              url: userData.profileImagePath,
                              isButton: false,
                            ),
                            SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  userData.name,
                                  style: GoogleFonts.lato(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Music Producer',
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 480,
                        width: 360,
                        child: PageView(
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          children:[
                            for(int i = 0; i < userData.cards.length; i++) //This creates a physical card for ever item in the cards list
                              enumToWidget( //this is where we pass in all of the data for all of the cards
                                userData.cards[i],
                                channelId: userData.ytChannelId,
                                bioTitle: userData.bioTitle,
                                bioBody: userData.bioBody,
                                instagramPics: userData.instagramPics,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 360,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for(double i = 0; i < userData.cards.length; i++)
                              Container(
                                margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    color: (i == _currentPage) ? Colors.grey[700] : Colors.grey[850],
                                    shape: BoxShape.circle
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea( // Back Button
                child: Container(
                  width: 40,
                  margin: EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    shape: CircleBorder(),
                  ),
                  child: BackButton(
                    color: Colors.white,
                    //onPressed:(){},
                  ),
                ),
              ),
              SafeArea( //Edit Button
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      margin: EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: (){Navigator.pushNamed(context, '/user-info');},
                      ),
                    ),
                    Container(
                      width: 40,
                      margin: EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.ad_units,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: (){Navigator.pushNamed(context, '/card-manager');},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) : Loading();

        // return Scaffold(
        //   backgroundColor: Colors.black,
        //   appBar: AppBar(
        //     backgroundColor: Colors.pink[500],
        //     actions: <Widget>[
        //       FlatButton.icon( //Edit
        //         icon: Icon(Icons.edit, size: 24),
        //         label: Text(
        //           'edit info',
        //           style: GoogleFonts.lato(
        //             fontSize: 18,
        //             color: Colors.grey[900],
        //           ),
        //         ),
        //         onPressed: (){Navigator.pushNamed(context, '/user-info');},
        //       ),
        //       FlatButton.icon( //card
        //         icon: Icon(Icons.ad_units, size: 24),
        //         label: Text(
        //           'manage cards',
        //           style: GoogleFonts.lato(
        //             fontSize: 18,
        //             color: Colors.grey[900],
        //           ),
        //         ),
        //         onPressed: (){Navigator.pushNamed(context, '/card-manager');},
        //       ),
        //     ],
        //   ),
        //   body:(snapshot.hasData) ? Container(
        //     //background image stuffs
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //         alignment: Alignment.topCenter,
        //         image: getBackgroundImage(userData.backgroundImagePath),
        //         colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        //       ),
        //     ),
        //     child: CustomScrollView(
        //       slivers: <Widget> [
        //         SliverAppBar(
        //           expandedHeight: 260.0,
        //           backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        //           pinned: false,
        //           floating: false,
        //           toolbarHeight: 0,
        //           flexibleSpace: FlexibleSpaceBar(
        //             background: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 if(userData.profileImagePath == '') BlankProfilePicture()
        //                 else Container(
        //                   width: 180,
        //                   height: 180,
        //                   decoration: BoxDecoration(
        //                     image: DecorationImage(
        //                       image: NetworkImage(userData.profileImagePath),
        //                       fit: BoxFit.cover,
        //                     ),
        //                     border: Border.all(width: 4, color: Colors.white),
        //                     borderRadius: BorderRadius.all(Radius.circular(100)),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             titlePadding: EdgeInsets.all(20),
        //             stretchModes: [StretchMode.blurBackground],
        //             title: ButtonBar(
        //                   alignment: MainAxisAlignment.spaceBetween,
        //                   children:[
        //                     // SizedBox(
        //                     //   width:50,
        //                     //   height:50,
        //                     //   child: FloatingActionButton(
        //                     //     heroTag: "cameraButton",
        //                     //     onPressed: () {getImage(ImageSource.camera);},
        //                     //     child: Icon(Icons.camera),
        //                     //     backgroundColor: Colors.pink[500],
        //                     //   ),
        //                     // ),
        //                     //Uploader(file: _selectedImage),
        //                     //SizedBox(width:50),
        //                     // SizedBox(
        //                     //   width:50,
        //                     //   height:50,
        //                     //   child: FloatingActionButton(
        //                     //     heroTag: "galleryButton",
        //                     //     onPressed: (){getImage(ImageSource.gallery);},
        //                     //     child: Icon(Icons.image),
        //                     //     backgroundColor: Colors.pink[500],
        //                     //   ),
        //                     // ),
        //                   ],
        //                 ),
        //             ),
        //           ),
        //         SliverList(
        //           delegate: SliverChildBuilderDelegate((BuildContext context, int index){
        //             return Container(
        //               child: Column(
        //                 children:<Widget> [
        //                   Container(
        //                     decoration: BoxDecoration(
        //                       color: Color.fromRGBO(50,50,50,0.6),//Color.fromRGBO(100,0,150,1),
        //                       boxShadow: [
        //                         // BoxShadow(
        //                         //   color:Colors.black,
        //                         //   blurRadius: 10,
        //                         //   offset: Offset(
        //                         //     0,
        //                         //     -5,
        //                         //   ),
        //                         // ),
        //                       ],
        //                     ),
        //                     child: Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           //SizedBox(width: 30),
        //                           Text(
        //                             userData.name,
        //                             style: GoogleFonts.lato(
        //                               fontSize: 24,
        //                               color: Colors.white,
        //                             ),
        //                           ),
        //
        //                           Text(
        //                             'Age: ' + userData.age,
        //                             style: GoogleFonts.lato(
        //                               fontSize: 24,
        //                               color: Colors.white,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                   Container(
        //                     height: 550,
        //                     color: Colors.black,
        //                     child: Center(
        //                       child: SizedBox(
        //                         height: cardHeight,
        //                         width: cardWidth,
        //                         child: PageView(
        //                           controller: _controller,
        //                           scrollDirection: Axis.horizontal,
        //                           children:[
        //                             for(int i = 0; i < userData.cards.length; i++) //This creates a physical card for ever item in the cards list
        //                               enumToWidget( //this is where we pass in all of the data for all of the cards
        //                                 userData.cards[i],
        //                                 channelId: userData.ytChannelId,
        //                                 bioTitle: userData.bioTitle,
        //                                 bioBody: userData.bioBody,
        //                               ),
        //                               /*if(userData.cards[i] == 'Youtube Card') enumToWidget(userData.cards[i], channelId: userData.ytChannelId)
        //                               else enumToWidget(userData.cards[i]),*/
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                   Container(
        //                     height:50,
        //                     color: Colors.grey[900],//Color.fromRGBO(100,0,150,1),
        //                     child: Center(
        //                       child: Text(
        //                         userData.location != [] ? userData.location[0] : '',
        //                         style: GoogleFonts.lato(
        //                           fontSize: 20,
        //                           color: Colors.white,
        //                         ),
        //                         textAlign: TextAlign.center,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             );
        //           },
        //             childCount: 1,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ) : Loading(),
        // );
      }
    );
  }
}