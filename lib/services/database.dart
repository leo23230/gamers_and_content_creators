import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gamers_and_content_creators/models/message_model.dart';
import 'package:gamers_and_content_creators/models/profile.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/user_preferences.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  // a reference to a collection in the Firestore database
  //this variable is used to add new documents, read, update, and remove existing documents
  final CollectionReference profilesCollection = FirebaseFirestore.instance.collection('profiles');
  final Geoflutterfire geo = Geoflutterfire();
  List<Profile> profiles = List<Profile>();

  //Used both to initialize the user data doc and update the existing doc with new data
  Future updateUserData({String name, String age, List<dynamic> location, dynamic geoHash, int month, int day, int year,
      String profileImagePath, String backgroundImagePath, List <dynamic> cards, String ytChannelId,
      String bioTitle, String bioBody}) async {
    return await profilesCollection.doc(uid).set({
      //If the optional named parameter = null we don't overwrite the existing value
      //could not use ternary operator
      if(name != null) 'name': name,
      if(age != null) 'age' : age,
      if (location != null) 'location' : location,
      if (geoHash != null) 'geoHash' :  geoHash,
      if (month != null) 'month' : month,
      if(day != null) 'day' : day,
      if(year != null) 'year': year,
      if(profileImagePath != null) 'profileImagePath': profileImagePath,
      if(backgroundImagePath != null) 'backgroundImagePath': backgroundImagePath,
      if(cards != null) 'cards': cards,
      if(ytChannelId != null) 'ytChannelId': ytChannelId,
      if(bioTitle != null)'bioTitle' : bioTitle,
      if(bioBody != null) 'bioBody' : bioBody,
    },
      //insures that we merge the data with the existing doc, and don't overwrite the entire doc
        SetOptions(merge:true),
    );
  }

  //Gets a profile from a query snapshot
  //Will use this for swiping screen (Home)
  List<Profile> _profileListFromSnapshot(List<DocumentSnapshot> docs) {
    //a map function that takes the list of documents and converts it to a list of Profile objects
    //perform a function for each document that takes the document and returns a single profile

    //for each document in the List of documents add a profile object to the profiles list
    for(final doc in docs) {
      profiles.add(Profile(
        name: doc.data()['name'] ?? '',
        //doc.data is a map, so we pass the key 'name' to get value
        age: doc.data()['age'] ?? '',
        location: doc.data()['location'] ?? [],
        geoHash: doc.data()['geoHash'] ?? null,
        month: doc.data()['month'] ?? 0,
        day: doc.data()['day'] ?? 0,
        year: doc.data()['year'] ?? 0,
        profileImagePath: doc.data()['profileImagePath'] ?? '',
        backgroundImagePath: doc.data()['backgroundImagePath'] ?? '',
        cards: doc.data()['cards'] ?? [],
        ytChannelId: doc.data()['ytChannelId'] ?? '',
        bioTitle: doc.data()['bioTitle'] ?? '',
        bioBody: doc.data()['bioBody'] ?? '',
      ));
    }
    return profiles;
  }

  //UserData from snapshot
  //takes the user doc snapshot and turns it into a UserData object
  //This is for profile settings
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      age: snapshot.data()['age'],
      location: snapshot.data()['location'],
      month: snapshot.data()['month'],
      day: snapshot.data()['day'],
      year: snapshot.data()['year'],
      profileImagePath: snapshot.data()['profileImagePath'],
      backgroundImagePath: snapshot.data()['backgroundImagePath'],
      cards: snapshot.data()['cards'],
      ytChannelId: snapshot.data()['ytChannelId'],
      bioTitle: snapshot.data()['bioTitle'],
      bioBody: snapshot.data()['bioBody'],
    );
  }

  //***MUST EVENTUALLY UPDATE WHEN RADIUS IS CHANGED!!!!****//
  //queries profiles collection in firebase based on location and max radius
  //returns a list of profile objects, so the data is easily accessible throughout the application

  mainQuery(double lat, double lng) async {
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);
    return await geo.collection(collectionRef: profilesCollection).within(
      center: center,
      radius: UserPreferences.getMaxRadius(),
      field: 'geoHash',
      strictMode: true,
    ).map(_profileListFromSnapshot);
  }

  //get profile stream
  //old system, opted for query instead of constant stream
  // Stream<List<Profile>> get profiles {
  //   return profilesCollection.snapshots().map(_profileListFromSnapshot);
  // }

  //stream that gets a profile snapshot from the uid and returns a UserData object
  Stream<UserData> get userData {
    return profilesCollection.doc(uid).snapshots().map(_userDataFromSnapshot); //every time the doc changes we get a snapshot
  }
}