import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gamers_and_content_creators/models/conversation.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/conversations_list.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/services/messaging_service.dart';
import 'package:gamers_and_content_creators/shared/profile_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> with AutomaticKeepAliveClientMixin<Matches>{
  List<UserData> matchesUserDataList = List<UserData>();
  UserData otherUserData;

  // Future<List<UserData>> getMatchesData (UserData userData) async{
  //   UserData tempUserData;
  //   List<String> userIds;
  //   print(userData.matches);
  //   if(matchesUserDataList.isEmpty){
  //     print('matchesUserDataList has no data');
  //     for(final userId in userData.matches){
  //       print('entered for loop');
  //       if(userId != ''){
  //         print('get user data');
  //         tempUserData = await DatabaseService(uid:userId).otherUserDataFromSnapshot();
  //         print('adding user data to list');
  //         print(tempUserData.name);
  //         matchesUserDataList.add(tempUserData);
  //       }
  //     }
  //     return matchesUserDataList;
  //   }
  //   else{
  //     return matchesUserDataList;
  //   }
  //
  //
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);
    UserData userData = Provider.of<UserData>(context);

    super.build(context);

    return StreamProvider<List<Conversation>>.value(
      value: MessagingService(myUid: user.uid).conversations,
      child: ConversationsList(),
    );

    // return FutureBuilder(
    //   future: getMatchesData(userData),
    //   builder: (context, snapshot) {
    //     if(snapshot.hasData){
    //       return ListView.builder(
    //           itemCount: matchesUserDataList.length,
    //           itemBuilder: (context, index) {
    //             otherUserData = matchesUserDataList[index];
    //             return Card(
    //               color: Colors.grey[850],
    //               child: ListTile(
    //                 visualDensity: VisualDensity(vertical: 4),
    //                 onTap:(){},
    //                 leading: FlatButton(
    //                   onPressed: (){},
    //                   child: SizedBox(width: 60, height: 60, child: ProfileImage(url: otherUserData.profileImagePath))
    //                 ),
    //                 title: Text(
    //                   otherUserData.name,
    //                   style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
    //                 ),
    //                 trailing: Icon(
    //                   Icons.arrow_right,
    //                   size: 50,
    //                 ),
    //               ),
    //             );
    //           }
    //       );
    //     }
    //     else if (snapshot.hasError){
    //       print(snapshot.error);
    //       return Center(
    //         child: Text(
    //           'Something went wrong ):',
    //           style: GoogleFonts.lato(fontSize: 28, color: Colors.grey[500]),
    //         ),
    //       );
    //     }
    //     else{
    //       return Loading();
    //     }
    //   }
    // );

     // return Column(
     //   mainAxisAlignment: MainAxisAlignment.center,
     //   children:[
     //   //   CarouselSlider(
     //   //     options: CarouselOptions(
     //   //       height:400,
     //   //       initialPage:0,
     //   //       enlargeCenterPage: true,
     //   //       enlargeStrategy: CenterPageEnlargeStrategy.scale,
     //   //       enableInfiniteScroll: false,
     //   //       viewportFraction: 0.6,
     //   //     ),
     //   //     items:<Widget>[
     //   //       Container(
     //   //         width:300,
     //   //         height: 400,
     //   //         decoration: BoxDecoration(
     //   //           color: Colors.grey[800],
     //   //           border: Border.all(color: Colors.white),
     //   //           borderRadius: BorderRadius.circular(10),
     //   //         ),
     //   //         child: Padding(
     //   //           padding: const EdgeInsets.all(15.0),
     //   //           child: Column(
     //   //             children: [
     //   //               SizedBox(height: 125, width: 125, child: Image.asset('assets/Noah.png')),
     //   //               SizedBox(height: 20),
     //   //               Text('Noah', style: GoogleFonts.lexendDeca(fontSize: 24, color: Colors.white)),
     //   //               SizedBox(height:20.0),
     //   //               Column(
     //   //                 crossAxisAlignment: CrossAxisAlignment.start,
     //   //                 children: [
     //   //                   Text('Age: 24', style: GoogleFonts.lexendDeca(fontSize: 20, color: Colors.grey[500]), textAlign: TextAlign.left),
     //   //                   Text('Discord: Noah357', style: GoogleFonts.lexendDeca(fontSize: 20, color: Colors.grey[500])),
     //   //                 ],
     //   //               ),
     //   //               SizedBox(height:20.0),
     //   //               Text('Gamer', style: GoogleFonts.lexendDeca(fontSize: 22, color: Colors.red)),
     //   //               //SizedBox(height: 10),
     //   //               //Text('Discord: noah2118', style: TextStyle(fontSize: 16, color: Colors.white)),
     //   //             ],
     //   //           ),
     //   //         ),
     //   //       ),
     //   //       Container(
     //   //         width:240,
     //   //         height: 320,
     //   //         decoration: BoxDecoration(
     //   //           color: Colors.grey[800],
     //   //           border: Border.all(color: Colors.white),
     //   //           borderRadius: BorderRadius.circular(10),
     //   //         ),
     //   //         child: Padding(
     //   //           padding: const EdgeInsets.all(15.0),
     //   //           child: Column(
     //   //             children: [
     //   //               SizedBox(height: 125, width: 125, child: Image.asset('assets/MooShu.png')),
     //   //               SizedBox(height: 20),
     //   //               Text('MooShu', style: GoogleFonts.lato(fontSize: 24, color: Colors.white)),
     //   //               SizedBox(height:20.0),
     //   //               Column(
     //   //                 crossAxisAlignment: CrossAxisAlignment.start,
     //   //                 children: [
     //   //                   Text('Age: 64', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
     //   //                   Text('Discord: shoeman1', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
     //   //                 ],
     //   //               ),
     //   //               SizedBox(height:20.0),
     //   //               Text('Vlogger', style: GoogleFonts.lato(fontSize: 22, color: Colors.red)),
     //   //             ],
     //   //           ),
     //   //         ),
     //   //       ),
     //   //       Container(
     //   //         width:240,
     //   //         height: 320,
     //   //         decoration: BoxDecoration(
     //   //           color: Colors.grey[800],
     //   //           border: Border.all(color: Colors.white),
     //   //           borderRadius: BorderRadius.circular(10),
     //   //         ),
     //   //         child: Padding(
     //   //           padding: const EdgeInsets.all(15.0),
     //   //           child: Column(
     //   //             children: [
     //   //               SizedBox(height: 125, width: 125, child: Image.asset('assets/Chives.png')),
     //   //               SizedBox(height: 20),
     //   //               Text('Chives', style: GoogleFonts.lato(fontSize: 24, color: Colors.white)),
     //   //               SizedBox(height:20.0),
     //   //               Column(
     //   //                 crossAxisAlignment: CrossAxisAlignment.start,
     //   //                 children: [
     //   //                   Text('Age: 31', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
     //   //                   Text('Discord: sp1c3', style: GoogleFonts.lato(fontSize: 20, color: Colors.grey[500])),
     //   //                 ],
     //   //               ),
     //   //               SizedBox(height:20.0),
     //   //               Text('Content Creator', style: GoogleFonts.lato(fontSize: 22, color: Colors.red)),
     //   //             ],
     //   //           ),
     //   //         ),
     //   //       ),
     //   //     ],
     //   //   ),
     //   ],
     // );
  }
}
