import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamers_and_content_creators/models/profile.dart';
import 'package:gamers_and_content_creators/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  // a reference to a collection in the Firestore database
  //this variable is used to add new documents, read, update, and remove existing documents
  final CollectionReference profilesCollection = FirebaseFirestore.instance.collection('profiles');

  Future updateUserData(String name, String age, String location, int month, int day, int year,
      String profileImagePath, String backgroundImagePath) async {
    return await profilesCollection.doc(uid).set({
      'name': name,
      'age' : age,
      'location' : location,
      'month' : month,
      'day' : day,
      'year': year,
      'profileImagePath': profileImagePath,
      'backgroundImagePath': backgroundImagePath,

    });
  }


  //function that gets a profile from a query snapshot
  //Will use this for swiping screen (Home)
  List<Profile> _profileListFromSnapshot(QuerySnapshot snapshot) {
    //perform a function for each document that takes the document and returns a single profile
    return snapshot.docs.map((doc){
      return Profile(
        name: doc.data()['name'] ?? '',//doc.data is a map, so we pass the key 'name' to get value
        age: doc.data()['age'] ?? '0',
        location: doc.data()['location'] ?? '',
        month: doc.data()['month'] ?? 0,
        day: doc.data()['day'] ?? 0,
        year: doc.data()['year'] ?? 0,
        profileImagePath: doc.data()['profileImagePath'],
        backgroundImagePath: doc.data()['backgroundImagePath']
      );
    }).toList();
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
        backgroundImagePath: snapshot.data()['backgroundImagePath']
    );
  }

  //get profile stream
  Stream<List<Profile>> get profiles {
    return profilesCollection.snapshots().map(_profileListFromSnapshot);
  }

  //get user document stream
  Stream<UserData> get userData {
    return profilesCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot); //every time the doc changes we get a snapshot
  }
}