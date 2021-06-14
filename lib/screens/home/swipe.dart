import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/profile.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/screens/home/cards/youtube_card.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/user_data_form.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/services/messaging_service.dart';
import 'package:gamers_and_content_creators/shared/card_enum.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/screens/home/home.dart';
import'package:gamers_and_content_creators/models/channel_model.dart';
import 'package:gamers_and_content_creators/models/video_model.dart';
import 'package:gamers_and_content_creators/services/api_service.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/video_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
class Swipe extends StatefulWidget {
  @override
  _SwipeState createState() => _SwipeState();

  static _SwipeState of(BuildContext context) =>
      context.findAncestorStateOfType<_SwipeState>();
}

class _SwipeState extends State<Swipe> with AutomaticKeepAliveClientMixin<Swipe> {
  bool hasProfilePicture;
  bool hasLocation;
  bool hasCards;

  bool checkListCompleted;

  int checkListItemsCompletedOverall;

  Map<String, bool>checkList = Map<String, bool>();

  Map<String, String> checkListText = {
    'hasProfilePicture' : 'Set your profile picture',
    'hasLocation' : 'Set your location',
    'hasCards': 'Pick out some cards!',
  };


  bool checkListCompletion() {
    int checkListItemsCompleted = 0;

    checkList.forEach((key, val){
      if (val == true) checkListItemsCompleted += 1;
    });

    checkListItemsCompletedOverall = checkListItemsCompleted;

    if(checkListItemsCompleted == checkList.length) return true;
    else return false;
  }

  void updateWidget(){
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    UserData userData = Provider.of<UserData>(context);

    checkList = {
      'hasProfilePicture' : hasProfilePicture,
      'hasLocation' : hasLocation,
      'hasCards' : hasCards,
    };

    if(userData.profileImagePath != "") hasProfilePicture = true;
    else hasProfilePicture = false;
    if(userData.location[0] != "") hasLocation = true;
    else hasLocation = false;
    if(userData.cards.length > 1) hasCards = true;
    else hasCards = false;
    print(checkList);
    print(userData.cards);
    //getProfiles(user.uid, userData);
    super.build(context);

    if(checkListCompletion()){
      return (userData!= null) ? StreamProvider.value(
        value: DatabaseService(
          uid: user.uid,
          lat: userData.location[1],
          lng: userData.location[2],
          rad: userData.radius,
        ).profilesList,
        child: SwipeWidget(),
      ) : Loading();
    }
    else{
      return Checklist();
    }
  }
}

class SwipeWidget extends StatefulWidget {
  @override
  _SwipeWidgetState createState() => _SwipeWidgetState();
}

class _SwipeWidgetState extends State<SwipeWidget> {

  final double cardHeight = 480;
  final double cardWidth = 360;
  double opacity = 1.0;
  final _controller = PageController(
    initialPage: 0,
  );

  //Real Data Variables//
  Stream<dynamic> queryResultStream;
  int profileCounter = 0;
  List<Profile> currentProfileBatch = List<Profile>();
  Profile currentProfile;

  //FakeData//
  // final List <String> pics = [
  //   'assets/Bridget.png',
  //   'assets/Chives.png',
  //   'assets/Jack Circle.png',
  //   'assets/MooShu.png',
  //   'assets/Noah.png',
  //   'assets/Shu.png'
  // ];
  // final List <String> setups = [
  //   'assets/clean pc setup.jpg',
  //   'assets/pc setup 2.jpg',
  //   'assets/pc setup 3.jpg',
  //   'assets/pc setup 4.jpg',
  //   'assets/pc setup 5.jpg',
  //   'assets/pc setup 6.jpg'
  // ];
  // final List <String> names = [
  //   'Bridget',
  //   'Chives',
  //   'Jack',
  //   'MooShu',
  //   'Noah',
  //   'Shu'
  // ];
  // final List <String> ages = [
  //   '27',
  //   '31',
  //   '26',
  //   '64',
  //   '24',
  //   '32'
  // ];
  // final List <String> channels = [
  //   'UCH5mi85eqEm-bOLvc69Lpaw',//'UCvYUyKg7wDj760PippmWhig',
  //   'UCBa659QWEk1AI4Tg--mrJ2A',
  //   'UCgFvT6pUq9HLOvKBYERzXSQ',
  //   'UCxzC4EngIsMrPmbm6Nxvb-A',
  //   'UCq3Wpi10SyZkzVeS7vzB5Lw',
  //   'UCq6aw03lNILzV96UvEAASfQ',
  // ];
  //int personIndex = 0;
  ////

  bool _isLoading = false;
  String currentChannelId; //just to launch the channel

  Future<List<Profile>> getProfiles(String uid, UserData userData) async {
    //List<Profile> queryResultProfiles;
    if(currentProfileBatch == null){ //this if statement is needed since the future builder rebuilds each time
      print(userData.location);
      queryResultStream = await DatabaseService(uid: uid).mainQuery(userData.location[1], userData.location[2]);
      queryResultStream.listen((value){currentProfileBatch = value;});
      //print(currentProfileBatch[0].name.toString());
      return currentProfileBatch;
    }
    else{
      return currentProfileBatch;
    }
  }
  List<Profile> filterProfiles (UserData userData) {
    List<Profile> currentProfileBatchUnfiltered = currentProfileBatch;
    for (final profile in currentProfileBatchUnfiltered){ //filter through results
      if(profile.uid == userData.uid) currentProfileBatch.remove(profile);
    }
    return currentProfileBatch;
  }
  Future like(Profile currentProfile, UserData userData, String myUid) async{
    //**Scenario One:  User has already been liked by other user**//
    //MATCH//
    print(myUid);
    print(currentProfile.uid);
    print(userData.liked);
    print(userData.matches);
    print(currentProfile.liked);
    print(currentProfile.matches);

    List<dynamic> myMatches = userData.matches;
    List<dynamic> myLiked = userData.liked;

    List<dynamic> otherMatches = currentProfile.matches;
    List<dynamic> otherLikes = currentProfile.liked;

    bool match;

    if(currentProfile.liked.contains(myUid)) match = true;
    else match = false;
    //Set the matches and liked list in the firebase doc to the updated myMatches and myLiked list
    print(myMatches);
    if(match) {
      print('its a match');
      //Add the current profile's uid to current USER'S Matches
      myMatches.add(currentProfile.uid); //add to list//print it
      //***Make sure the current user's uid appears in the other user's matches list***//
      //also make sure to remove the current user's uid from the other user's liked list
      otherMatches.add(myUid); //add to list
      otherLikes.remove(myUid); //print it
      //**Create a conversation for the two users**//
      match = true;
      await MessagingService(myUid: myUid, otherUid: currentProfile.uid,
          myName: userData.name, myUrl: userData.profileImagePath,
          otherName: currentProfile.name, otherUrl: currentProfile.profileImagePath)
          .createConversation(); //The class needs all of the optional named parameters to use this function
    }
    else{
      //Just add the user to the myLiked list//
      myLiked.add(currentProfile.uid);
    }

    await DatabaseService(uid: myUid).updateUserData(
      liked: myLiked,
      matches: myMatches,
    );
    // Set the other user's liked and matches lists
    await DatabaseService(uid: currentProfile.uid).updateUserData(
      liked: otherLikes,
      matches: otherMatches,
    );

    if(profileCounter < currentProfileBatch.length-1){
      profileCounter += 1;
      setState((){});
      currentProfile = currentProfileBatch[profileCounter];
      //_initChannel();
    }
    else{
      profileCounter = 0;
      setState((){});
      currentProfile = currentProfileBatch[profileCounter];
      //_initChannel();
    }
    return;
  }

  //Image Widgets//
  Widget blankProfilePicture(){
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
  ImageProvider getBackgroundImage(String existingBackgroundImagePath){
    if(existingBackgroundImagePath != ''){
      return NetworkImage(existingBackgroundImagePath);
    }
    else{
      return AssetImage('assets/clean pc setup.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);
    UserData userData = Provider.of<UserData>(context);
    currentProfileBatch = Provider.of<List<Profile>>(context);
    currentProfile = currentProfileBatch[profileCounter];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: getBackgroundImage(currentProfile.backgroundImagePath),
          colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget> [
          SliverAppBar(
            expandedHeight: 260.0,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0),
            pinned: false,
            floating: false,
            toolbarHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Opacity(
                  opacity: opacity,
                  child: FlatButton(
                    onPressed: (){
                      setState((){});
                    },
                    child: (currentProfile.profileImagePath == '') ? blankProfilePicture() :
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(currentProfile.profileImagePath),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(width: 4, color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                  )
              ),
              title: ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children:[
                  SizedBox(
                    width:50,
                    height:50,
                    child: FloatingActionButton(
                      heroTag: "pass",
                      onPressed: () {
                        if(profileCounter < currentProfileBatch.length -1){
                          profileCounter += 1;
                          setState((){});
                          currentProfile = currentProfileBatch[profileCounter];
                          //_initChannel();
                        }
                        else{
                          profileCounter = 0;
                          setState((){});
                          currentProfile = currentProfileBatch[profileCounter];
                          //_initChannel();
                        }
                      },
                      child: Icon(Icons.remove),
                      backgroundColor: Colors.pink[500],
                    ),
                  ),
                  //SizedBox(width:50),
                  SizedBox(
                    width:50,
                    height:50,
                    child: FloatingActionButton(
                      heroTag: "like",
                      onPressed: () async{
                        //figures out which list to put the liked user in based on two scenarios
                        await like(currentProfile, userData, user.uid);
                      },
                      child: Icon(Icons.people),
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
                        color: Color.fromRGBO(50,50,50,0.6),//Color.fromRGBO(100,0,150,1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //SizedBox(width: 30),
                            Text(
                              currentProfile.name,
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            //SizedBox(width: 190),
                            Text(
                              'Age: ' + currentProfile.age,
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
                              for(int i = 0; i < currentProfile.cards.length; i++) //This creates a physical card for ever item in the cards list
                                enumToWidget( //this is where we pass in all of the data for all of the cards
                                  currentProfile.cards[i],
                                  channelId: currentProfile.ytChannelId,
                                  bioTitle: currentProfile.bioTitle,
                                  bioBody: currentProfile.bioBody,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height:50,
                      color: Colors.grey[900],//Color.fromRGBO(100,0,150,1),
                      child: Center(
                        child: Text(
                          currentProfile.location != [] ? currentProfile.location[0] : '',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
    );
  }
}

class Checklist extends StatefulWidget {
  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text(
            'Welcome!',
            style: GoogleFonts.lato(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Before you get started, we just need a little more information!',
            style: GoogleFonts.lato(
              fontSize: 24,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(24),
              child: Column(
                children: [
                  for(int i = 0; i < Swipe.of(context).checkList.values.length; i++ )
                    if (Swipe.of(context).checkList.values.toList()[i] == false)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Card(
                          color: Colors.grey[850],
                          child: ListTile(
                            onTap: () async{
                              var value;
                              if(Swipe.of(context).checkList.keys.toList()[i] == 'hasCards'){
                                value = await Navigator.pushNamed(context, '/card-manager');
                              }
                              else{
                                value = await Navigator.pushNamed(context, '/user-info');
                              }
                              setState(() {
                                print('back');
                                Swipe.of(context).updateWidget();
                              });
                            },
                            leading: Icon(Icons.check_box_outline_blank),
                            title: Text(
                                      Swipe.of(context).checkListText[Swipe.of(context).checkList.keys.toList()[i]],
                                      style: GoogleFonts.lato(
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                  SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: Swipe.of(context).checkListItemsCompletedOverall.toDouble() / Swipe.of(context).checkList.length,
                    backgroundColor: Colors.grey[900],
                    minHeight: 10,
                  ),
                  if(Swipe.of(context).checkListItemsCompletedOverall == Swipe.of(context).checkList.length - 1)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: Text(
                        'Almost there!',
                        style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                      ),
                    ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
