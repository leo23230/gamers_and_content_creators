import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/google_auth.dart';
import 'package:gamers_and_content_creators/shared/card_enum.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String youtubeChannelId;

  @override
  Widget build(BuildContext context) {

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
          backgroundColor: Colors.pink[500],
        ),
        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            primary: true,
            children: [
              CardDeck(),
              CardPicker(),
            ],
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

  List<dynamic> myItems;// = [DuwoCard.youtube, DuwoCard.twitch, DuwoCard.bio];
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
            onPressed: () async{
              await DatabaseService(uid: user.uid).updateUserData(
                //We don't need to update these values here
                userData.name,
                userData.age,
                userData.location,
                userData.month,
                userData.day,
                userData.year,
                userData.profileImagePath,
                userData.backgroundImagePath,
                //
                myItems,
                RealCardManager.of(context).youtubeChannelId ?? userData.ytChannelId,
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
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    UserData userData = Provider.of<UserData>(context);
    // for(int i = 0; i < allCards.length; i++){
    //   if((widget.addableCards.length < allCards.length - userData.cards.length) && (!widget.addableCards.contains(allCards[i]))) widget.addableCards.add(allCards[i]);
    //   for(int j = 0; j < userData.cards.length; j++){
    //     if(allCards[i] == userData.cards[j]){
    //       widget.addableCards.remove(allCards[i]);
    //     }
    //   }
    // }
    return GridView.count(
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
                      RealCardManager.of(context).youtubeChannelId= await signInWithGoogle();
                      break;
                    case 'Twitch Card':
                      break;
                    case 'Bio Card':
                      break;
                  }
                  setState((){
                    RealCardManager.of(context).activeCards.add(item);
                    RealCardManager.of(context).addableCards.remove(item);
                  });
                },
              ),
            ],

          ),
      ],
    );
  }
}
