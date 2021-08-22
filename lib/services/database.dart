import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gamers_and_content_creators/models/message_model.dart';
import 'package:gamers_and_content_creators/models/profile.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:gamers_and_content_creators/services/user_preferences.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DatabaseService {

  final String uid;
  final double lat;
  final double lng;
  final int rad;
  final int minAge;
  final int maxAge;
  DatabaseService({this.uid, this.lat, this.lng, this.rad, this.minAge, this.maxAge});

  // collection reference
  // a reference to a collection in the Firestore database
  //this variable is used to add new documents, read, update, and remove existing documents
  final CollectionReference profilesCollection = FirebaseFirestore.instance.collection('profiles');
  final Geoflutterfire geo = Geoflutterfire();
  List<Profile> profiles = List<Profile>();

  //Used both to initialize the user data doc and update the existing doc with new data
  Future updateUserData({String userId, String name, String age, List<dynamic> location, dynamic geoHash,
    int month, int day, int year, String profileImagePath, String backgroundImagePath, int radius, int ageMin, int ageMax,
    List <dynamic> cards, String ytChannelId, String bioTitle, String bioBody, List<dynamic> instagramPics,
    List<dynamic> liked, List<dynamic> passed, List<dynamic> matches,}) async {
    return await profilesCollection.doc(uid).set({
      //If the optional named parameter = null we don't overwrite the existing value
      //could not use ternary operator
      if(userId != null) 'uid' : userId,
      if(name != null) 'name': name,
      if(age != null) 'age' : age,
      if (location != null) 'location' : location,
      if (geoHash != null) 'geoHash' :  geoHash,
      if (month != null) 'month' : month,
      if(day != null) 'day' : day,
      if(year != null) 'year': year,
      if(profileImagePath != null) 'profileImagePath': profileImagePath,
      if(backgroundImagePath != null) 'backgroundImagePath': backgroundImagePath,
      if(radius != null) 'radius' : radius,
      if(ageMin != null) 'ageMin' : ageMin,
      if(ageMax != null) 'ageMax' : ageMax,

      if(cards != null) 'cards': cards,
      if(ytChannelId != null) 'ytChannelId': ytChannelId,
      if(bioTitle != null)'bioTitle' : bioTitle,
      if(bioBody != null) 'bioBody' : bioBody,
      if(instagramPics != null) 'instagramPics' : instagramPics,

      if(liked != null) 'liked' : liked,
      if(passed != null) 'passed' : passed,
      if(matches != null) 'matches' : matches,
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
        //doc.data is a map, so we pass the key 'name' to get value
        uid: doc.data()['uid'] ?? '',
        name: doc.data()['name'] ?? '',
        age: doc.data()['age'] ?? '',
        location: doc.data()['location'] ?? [''],
        geoHash: doc.data()['geoHash'] ?? null,
        month: doc.data()['month'] ?? 0,
        day: doc.data()['day'] ?? 0,
        year: doc.data()['year'] ?? 0,
        profileImagePath: doc.data()['profileImagePath'] ?? '',
        backgroundImagePath: doc.data()['backgroundImagePath'] ?? '',
        radius: doc.data()['radius'] ?? 0.0,
        minAge: doc.data()['minAge'] ?? 0,
        maxAge: doc.data()['maxAge'] ?? 0,
        cards: doc.data()['cards'] ?? [''],
        ytChannelId: doc.data()['ytChannelId'] ?? '',
        bioTitle: doc.data()['bioTitle'] ?? '',
        bioBody: doc.data()['bioBody'] ?? '',
        instagramPics: doc.data()['instagramPics'] ?? [''],
        liked: doc.data()['liked'] ?? [''],
        passed: doc.data()['passed'] ?? [''],
        matches: doc.data()['matches'] ?? [''],
      ));
    }
    return profiles;
  }

  //UserData from snapshot
  //takes the user doc snapshot and turns it into a UserData object
  //This is for profile settings
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid:uid,
      name: snapshot.data()['name'],
      age: snapshot.data()['age'],
      location: snapshot.data()['location'],
      month: snapshot.data()['month'],
      day: snapshot.data()['day'],
      year: snapshot.data()['year'],
      profileImagePath: snapshot.data()['profileImagePath'],
      backgroundImagePath: snapshot.data()['backgroundImagePath'],
      radius: snapshot.data()['radius'],
      minAge: snapshot.data()['minAge'],
      maxAge: snapshot.data()['maxAge'],
      cards: snapshot.data()['cards'],
      ytChannelId: snapshot.data()['ytChannelId'],
      bioTitle: snapshot.data()['bioTitle'],
      bioBody: snapshot.data()['bioBody'],
      instagramPics: snapshot.data()['instagramPics'],
      liked: snapshot.data()['liked'],
      passed: snapshot.data()['passed'],
      matches: snapshot.data()['matches'],
    );
  }

  //***MUST EVENTUALLY UPDATE WHEN RADIUS IS CHANGED!!!!****//
  //queries profiles collection in firebase based on location and max radius
  //returns a list of profile objects, so the data is easily accessible throughout the application

  mainQuery(double lat, double lng) {
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);
    return geo.collection(collectionRef: profilesCollection).within(
      center: center,
      radius: UserPreferences.getMaxRadius(),
      field: 'geoHash',
      strictMode: true,
    ).map(_profileListFromSnapshot);
  }

  Future<UserData> otherUserDataFromSnapshot ()async{
    DocumentSnapshot doc;
    UserData otherUserData;
    doc = await profilesCollection.doc(uid).get();
    otherUserData = _userDataFromSnapshot(doc);
    return otherUserData;
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

  Stream<List<Profile>> get profilesList {
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);
    return geo.collection(collectionRef: profilesCollection)
      .within(
        center: center,
        radius: rad.toDouble(),
        field: 'geoHash',
        strictMode: true,
      )
      .map(_profileListFromSnapshot);
  }
}