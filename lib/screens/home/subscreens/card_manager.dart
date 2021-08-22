import 'package:flutter/material.dart';
//import 'package:flutter_instagram_image_picker/flutter_instagram_image_picker.dart';
//import 'package:flutter_instagram_image_picker/screens.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/google_auth.dart';
import 'package:gamers_and_content_creators/shared/card_enum.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_media/instagram_media.dart';
import'package:provider/provider.dart';
import 'package:gamers_and_content_creators/services/database.dart';

class CardManager extends StatefulWidget {
  @override
  _CardManagerState createState() => _CardManagerState();
}

class _CardManagerState extends State<CardManager> {
  @override
  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);

    return StreamProvider.value(
      value: DatabaseService(uid: user.uid).userData,
      child: RealCardManager(),
    );
  }
}


class RealCardManager extends StatefulWidget {
  @override
  _RealCardManagerState createState() => _RealCardManagerState();

  static _RealCardManagerState of(BuildContext context) =>
      context.findAncestorStateOfType<_RealCardManagerState>();
}

class _RealCardManagerState extends State<RealCardManager> {

  List<dynamic> activeCards;
  List<dynamic> addableCards = List<dynamic>();
  ValueNotifier<int> addableCardLength;
  //Profile Update Variables//
  String youtubeChannelId;
  String bioTitle;
  String bioBody;
  List<dynamic> instagramPics;

  @override
  Widget build(BuildContext context) {

    addableCardLength = ValueNotifier<int>(addableCards.length); //whenever the length changes it'll notify listenable builders

    UserModel user = Provider.of<UserModel>(context);
    UserData userData = Provider.of<UserData>(context);
    if (activeCards == null) activeCards = userData.cards;

    //create addable card list
    for(int i = 0; i < allCards.length; i++){
      if((addableCards.length < allCards.length - userData.cards.length) && (!addableCards.contains(allCards[i]))) addableCards.add(allCards[i]);
      for(int j = 0; j < userData.cards.length; j++){
        if(allCards[i] == userData.cards[j]){
          addableCards.remove(allCards[i]);
        }
      }
    }

    return StreamProvider<UserData>.value(
      value: DatabaseService(uid: user.uid).userData,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar:AppBar(
          title: Text(
            'Card Manager',
            style: GoogleFonts.lato(fontSize: 24,),
          ),
          backgroundColor: Colors.pink[500],
        ),
        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder<int>(
            valueListenable: addableCardLength,
            builder: (context, addableCardLength, _){
              return ListView(
                primary: true,
                children: [
                  CardDeck(),
                  CardPicker(),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
class CardDeck extends StatefulWidget {
  @override
  _CardDeckState createState() => _CardDeckState();
}

class _CardDeckState extends State<CardDeck> {

  List<dynamic> myItems;
  String _youtubeChannelId;

  @override
  Widget build(BuildContext context) {

    myItems = RealCardManager.of(context).activeCards;

    UserModel user = Provider.of<UserModel>(context);
    UserData userData = Provider.of<UserData>(context);
    //if (myItems == null) myItems = userData.cards; //so set state does not wipe data
    return Container(//Card Deck Top
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[850], width: 4),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[850],
      ),
      height: 292,
      child: Column(
        children: [
          Text(
            'Card Deck',
            style: GoogleFonts.lato(fontSize: 28, color: Colors.white),
          ),
          SizedBox(height: 6),
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[800], width: 4),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[800],
              ),
              height: 190,
              child: ReorderableListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for(final item in myItems)
                    Card(
                      key: ValueKey(item),
                      elevation: 4,
                      child: Stack(
                        children: [
                          stringToPreview(item),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            enableFeedback: true,
                            onPressed: () async{
                              switch(item){
                                case 'Youtube Card':
                                  _youtubeChannelId = '';
                                  await signOutOfGoogle();
                                  break;
                                case 'Twitch Card':
                                  break;
                                case 'Bio Card':
                                  break;
                              }
                              setState((){
                                RealCardManager.of(context).activeCards.remove(item);
                                RealCardManager.of(context).addableCards.add(item);
                                RealCardManager.of(context).addableCardLength.value = RealCardManager.of(context).addableCards.length;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
                onReorder: (oldIndex, newIndex){
                  setState((){
                    if(newIndex > oldIndex){
                      newIndex -=1;
                    }
                    final item = myItems.removeAt(oldIndex);
                    myItems.insert(newIndex, item);
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 6),
          RaisedButton(
            color: Colors.pink[500],
            child: Text(
              'Update',
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            ////UPDATE BUTTON
            onPressed: () async{
              await DatabaseService(uid: user.uid).updateUserData(
                //We don't need to update the other values here
                cards: myItems,
                ytChannelId: RealCardManager.of(context).youtubeChannelId ?? userData.ytChannelId,
                bioTitle: RealCardManager.of(context).bioTitle ?? userData.bioTitle,
                bioBody: RealCardManager.of(context).bioBody ?? userData.bioBody,
                instagramPics: RealCardManager.of(context).instagramPics ?? userData.instagramPics,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class CardPicker extends StatefulWidget {
  List<dynamic> addableCards = List<dynamic>();
  CardPicker({this.addableCards});
  @override
  _CardPickerState createState() => _CardPickerState();
}

class _CardPickerState extends State<CardPicker> {

  final _formKey = GlobalKey<FormState>();

  //These variables hold the user Input until the update button is pushed
  String _tempBioTitle;
  String _tempBioBody;
  List<dynamic> _tempInstagramPics;

  @override

  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);
    UserData userData = Provider.of<UserData>(context);

    //Functions for switch statement//
    Future bioForm() async {
      Future future = showModalBottomSheet (context: context, builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.white,
              width: 2,
            )
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Edit Bio Card',
                    style: GoogleFonts.lato(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox( //title
                    width: 250,
                    child: TextFormField(
                      initialValue: userData.bioTitle,
                      decoration: textInputDecoration,
                      validator: (val) => val.length > 10 ? 'Title must be less than 10 characters' : null,
                      onChanged: (val) {_tempBioTitle = val;},
                    ),
                  ),
                  SizedBox(height: 10),//space
                  SizedBox( //body
                    width: 250,
                    //height: 250,
                    child: TextFormField(
                      initialValue: userData.bioBody,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Type your bio here',
                      ),
                      minLines: 3,
                      maxLines: 4,
                      //validator: (val) => val.isEmpty ? 'Please Enter Title' : null,
                      onChanged: (val) {_tempBioBody = val;},
                    ),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.pink[500],
                    child: Text(
                      'Done',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if(_formKey.currentState.validate()){
                        Navigator.pop(context);
                      }
                      //return "Done Updating Bio Card";
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
      await future.then((void value) => "Done Updating"); //Essential for keeping the variables from updating before the modal sheet closes
    }

    Future instagramLogin (context) async {
      final result = await Navigator.push(
          context,
        MaterialPageRoute(
            builder: (context) => InstagramMedia(
              appID: '1138567009886689',
              appSecret: '45626dbe26074cbd743579ae5af9fe65',
              mediaTypes: 0,
            )
        )
      );
      setState(() {
        _tempInstagramPics = result[0];
      });
      //print(result);
    }

    return Flexible(
      child: Container(
        margin: EdgeInsets.fromLTRB(0,8,0,0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[850],
        ),
        child: Column(
          children: [
            Text(
              'Card Library',
              style: GoogleFonts.lato(fontSize: 28, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: GridView.count(
                primary: false,
                scrollDirection: Axis.vertical,
                crossAxisCount: 3,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                shrinkWrap: true,
                childAspectRatio: 0.75,
                children:[
                  for(final item in RealCardManager.of(context).addableCards)
                    Stack(
                      children: [
                        Card(
                          child: stringToPreview(item),
                          elevation: 4,
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: ()async{
                            switch(item){
                              case 'Youtube Card':
                                RealCardManager.of(context).youtubeChannelId = await signInWithGoogle();
                                break;
                              case 'Twitch Card':
                                break;
                              case 'Bio Card':
                                await bioForm();
                                //this is done to prevent null varaible to overwrite existing data
                                if(_tempBioTitle != null) RealCardManager.of(context).bioTitle = _tempBioTitle;
                                if(_tempBioBody != null) RealCardManager.of(context).bioBody = _tempBioBody;
                                break;
                              case 'Instagram Card':
                                await instagramLogin(context);
                                if(_tempInstagramPics != null) RealCardManager.of(context).instagramPics = _tempInstagramPics;
                                break;
                            }
                            setState((){
                              RealCardManager.of(context).activeCards.add(item);
                              RealCardManager.of(context).addableCards.remove(item);
                              RealCardManager.of(context).addableCardLength.value = RealCardManager.of(context).addableCards.length;
                            });
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}