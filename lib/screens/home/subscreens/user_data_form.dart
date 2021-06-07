import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/map.dart';
import 'package:gamers_and_content_creators/services/upload.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';
import 'package:gamers_and_content_creators/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/services/database.dart';
import 'package:gamers_and_content_creators/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:age/age.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamers_and_content_creators/services/google_auth.dart';
import 'package:http/http.dart' as http;
import 'package:search_map_place/search_map_place.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserDataForm extends StatefulWidget {
  @override
  _UserDataFormState createState() => _UserDataFormState();

  static _UserDataFormState of(BuildContext context) =>
      context.findAncestorStateOfType<_UserDataFormState>();
}

class _UserDataFormState extends State<UserDataForm> {
  User user;
  http.Response response;

  //Location Stuff//
  Geolocation geolocation; //set this in seperate widget
  String place;
  List<dynamic> mapData;
  ValueNotifier<String> placeNotifier;
  Geoflutterfire geo = Geoflutterfire();

  bool loading = false;
  File _selectedImage;
  File _profileImage;
  File _backgroundImage;
  String _profileImageUrl;
  String _backgroundImageUrl;

  //form keys
  final _formKey = GlobalKey<FormState>();
  final _dobFormKey = GlobalKey<FormState>();


  // text field state / firestore variables
  String _name;
  String _age;
  int _monthNumber;
  int _day;
  int _year;
  String error = '';
  List<dynamic> _location; //used for storing in firebase
  dynamic _geoHash;


  // Arrays For Drop Down Button Form Fields
  List <String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  List <int> days = [];
  int numberOfDays = 0; // For auto populating for loop
  List <int> years = [];

  //Functions for Date of Birth
  bool isThirtyOne () {
    if(_monthNumber == 1 || _monthNumber == 3 || _monthNumber == 5||
        _monthNumber == 7 || _monthNumber == 8 || _monthNumber == 10 ||
        _monthNumber == 12){
      return true;
    }
    else{
      return false;
    }
  }
  bool isFebruary () {
    if(_monthNumber == 2){
      return true;
    }
    else{
      return false;
    }
  }

  int monthCalculation(val){
    _monthNumber = val;
    if(isThirtyOne()) numberOfDays = 31;
    else if (isFebruary()) numberOfDays = 28;
    else numberOfDays = 30;
    days = []; //resets the days array
    for(int i = 0; i < numberOfDays; i++){
      days.add(i+1);
    }
    return _monthNumber;
  }

  //get Image function
  getImage(ImageSource source, double ratX, double ratY) async{
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: ratX, ratioY: ratY),
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
      setState((){_selectedImage = croppedImage;});
    }
  }

  Widget getImageWidget({String existingProfileImagePath}){
    if(_profileImage == null){
      if(existingProfileImagePath != ''){
        return Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(existingProfileImagePath),
              fit: BoxFit.cover,
            ),
            border: Border.all(width: 4, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        );
      }
      else{
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
    }
    else{
      return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(_profileImage),
            fit: BoxFit.cover,
          ),
          border: Border.all(width: 4, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(90)),
        ),
      );
    }
  }

  ImageProvider getBackgroundImage(String existingBackgroundImagePath){
    if(_backgroundImage == null){
      if(existingBackgroundImagePath != ''){
        return NetworkImage(existingBackgroundImagePath);
      }
      else{
        return AssetImage('assets/clean pc setup.jpg');
      }
    }
    else{
      return FileImage(_backgroundImage);
    }
  }

  //GoogleSignIn

  //Main Build Function
  @override
  void _awaitReturnValueFromMap(BuildContext context, List<dynamic> existingLocationData) async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapWidget(
          existingLocationData: (existingLocationData != null) ? existingLocationData : null,
        )),
    );
    if(this.mounted){
      setState(() {
        //UI Variables//
        mapData = result;
        geolocation = mapData[0];
        place = mapData[1];
        placeNotifier.value = place;
        print(mapData[0].toString() + mapData[1]);

        //***UPDATE LOCATION LIST***//
        _location = [place, geolocation.coordinates.latitude, geolocation.coordinates.longitude];
        print(_location.toString());
      });
    }
  }

  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);

    placeNotifier = ValueNotifier<String>(place); //update value notifier when place changes
    //this exists only to update the state of the location form field

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data;

          //Preemptively calculates month to fill dropdown box
          if(userData.month!= 0){
            monthCalculation(_monthNumber);
          }

          return Scaffold(
            backgroundColor: Colors.black,
            appBar:AppBar(
              title: Text(
                'Edit Info',
                style: GoogleFonts.lato(fontSize: 24),
              ),
              backgroundColor: Colors.pink[500],
            ),
            body: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                //Everything else for the page is contained in this container
                //This is because I needed to place a camera button for the background image
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: getBackgroundImage(userData.backgroundImagePath),
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                    child: Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            getImageWidget(existingProfileImagePath: userData.profileImagePath),

                            //Black transparent circle with camera button
                            Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.7),
                                borderRadius: BorderRadius.all(Radius.circular(90)),
                              ),
                              child: IconButton( //camera button
                                iconSize: 60,
                                icon: Icon(Icons.camera_alt, color: Colors.white),
                                enableFeedback: true,
                                onPressed:(){
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(
                                        'Change Profile Image?',
                                        style: GoogleFonts.lato(fontSize: 18),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed:(() async{
                                            _selectedImage = null; //reset _selected image
                                            await getImage(ImageSource.camera, 1, 1);
                                            setState(() {
                                              if(_selectedImage != null)_profileImage = _selectedImage;
                                              Navigator.pop(context); //dismiss alert dialog
                                            });
                                          }),
                                          child: Text(
                                            'Camera',
                                            style: GoogleFonts.lato(fontSize: 16, color: Colors.pink[500]),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed:(() async{
                                            await getImage(ImageSource.gallery, 1, 1);
                                            setState(() {
                                              if(_selectedImage != null)_profileImage = _selectedImage;
                                              Navigator.pop(context); //dismiss alert dialog
                                            });
                                          }),
                                          child: Text(
                                            'Gallery',
                                            style: GoogleFonts.lato(fontSize: 16, color: Colors.pink[500]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    barrierDismissible: true,
                                  );
                                },
                              ),
                            ),
                          ],

                        ),
                        SizedBox(height: 60),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Text(
                                'Name',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(height: 8.0),
                              SizedBox( //Name Form Field
                                width: 250,
                                child: TextFormField(
                                  initialValue: userData.name,
                                  decoration: textInputDecoration,
                                  validator: (val) => val.isEmpty ? 'Enter a name' : null,
                                  onChanged: (val) {
                                    if(val.length > 1) {
                                      setState(() => _name = val);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Location',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                              ),
                              SizedBox( //Name Form Field
                                width: 250,
                                //listens for changes to 'place' variable
                                //updates this widget to display the chosen place
                                child: ValueListenableBuilder(
                                  valueListenable: placeNotifier,
                                  builder: (context, placeNotifier, _){
                                    return TextFormField(
                                    decoration: textInputDecoration.copyWith(hintText: place ?? userData.location[0] ?? 'Select Your Location'),
                                    readOnly: true,
                                    onTap: (){
                                      //check if userData.location is not empty
                                      _awaitReturnValueFromMap(context, userData.location);
                                      },
                                    );
                                  }
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Date of Birth',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(height: 10.0),
                              Form(
                                key: _dobFormKey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: DropdownButtonFormField(
                                        value: userData.month,
                                        items: months.map((month){
                                          return DropdownMenuItem(
                                            value: months.indexOf(month) + 1,
                                            child: Text(month, style: GoogleFonts.lato(fontSize: 16)),
                                          );
                                        }).toList(),
                                        decoration: textInputDecoration,
                                        validator: (val) => val == null ? 'Enter a month' : null,
                                        onTap: ((){_dobFormKey.currentState.reset();}),
                                        onChanged: (val) => setState(() {
                                          _monthNumber = val;
                                          if(isThirtyOne()) numberOfDays = 31;
                                          else if (isFebruary()) numberOfDays = 28;
                                          else numberOfDays = 30;
                                          days = [];
                                          for(int i = 0; i < numberOfDays; i++){
                                            days.add(i+1);
                                          }
                                          return _monthNumber;
                                        }),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    SizedBox( //Day Drop Down
                                      width: 75,
                                      child: DropdownButtonFormField(
                                        value: userData.day,
                                        items: days.map((day){
                                          return DropdownMenuItem(
                                            value: day,
                                            child: Text(day.toString(), style: GoogleFonts.lato(fontSize: 16)),
                                          );
                                        }).toList(),
                                        decoration: textInputDecoration,
                                        validator: (val) => val == null ? 'Enter #' : null,
                                        onChanged: (val) => setState(() {_day = val;}),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    SizedBox( //Year Text Form Field
                                      width: 125,
                                      child: TextFormField(
                                        initialValue: userData.year.toString(),
                                        decoration: textInputDecoration,
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          var now = new DateTime.now();
                                          if(now.year - int.parse(val) > 124 || int.parse(val) > now.year){
                                            return 'Enter a valid year';
                                          }
                                          else return null;
                                        },
                                        onChanged: (val) {setState(() => _year = int.parse(val));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),

                              //The Update Button
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

                                  //need to do this since these are required
                                  _day == null ? _day = userData.day : null;
                                  _monthNumber == null ? _monthNumber = userData.month : null;
                                  _year == null ? _year = userData.year : null;

                                  //if the forms are valid
                                  if(_formKey.currentState.validate() && _dobFormKey.currentState.validate()){
                                    var now = new DateTime.now();
                                    var dob = new DateTime(_year,_monthNumber, _day);
                                    _age = Age.dateDifference(fromDate: dob, toDate: now, includeToDate:false).years.toString();

                                    if(int.parse(_age) >= 18 && int.parse(_age) <= 124){
                                      //upload profile image if there is one

                                      if(_profileImage != null){
                                        _profileImageUrl = await PictureUploader(uid: user.uid, file: _profileImage, fileName: 'profile-picture').startUpload();
                                      }
                                      //upload background image if there is one
                                      if(_backgroundImage != null){
                                        _backgroundImageUrl = await PictureUploader(uid: user.uid, file: _backgroundImage, fileName: 'background-picture').startUpload();
                                      }

                                      //get geohash from new location if there is any
                                      if(_location != null){
                                        GeoFirePoint point = geo.point(latitude: _location[1], longitude: _location[2]);
                                        _geoHash = point.data;
                                      }

                                      //update user data
                                      await DatabaseService(uid: user.uid).updateUserData(
                                        name: _name ?? userData.name,
                                        age: _age ?? userData.age,
                                        location: _location ?? userData.location,
                                        geoHash: _geoHash ?? userData.geoHash,
                                        month: _monthNumber ?? userData.month,
                                        day: _day ?? userData.day,
                                        year: _year ?? userData.year,
                                        profileImagePath: _profileImageUrl ?? userData.profileImagePath,
                                        backgroundImagePath: _backgroundImageUrl ?? userData.backgroundImagePath,
                                        // userData.cards,
                                        // ytChannelId: channelId ?? userData.ytChannelId,
                                        // userData.bioTitle,
                                        // userData.bioBody,
                                      );
                                      //pop back to profile screen
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                error,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red, fontSize: 14.0),
                              ),
                              SizedBox(height: 12.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Camera Button For Background Image
                IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  enableFeedback: true,
                  onPressed:(){
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          'Change Background Image?',
                          style: GoogleFonts.lato(fontSize: 18),
                        ),
                        actions: [
                          FlatButton(
                            onPressed:(() async{
                              _selectedImage = null; //reset _selected image
                              await getImage(ImageSource.camera, 4, 3); //this sets _selectedImage
                              setState(() {
                                if(_selectedImage != null)_backgroundImage = _selectedImage;
                                Navigator.pop(context); //dismiss alert dialog
                              });
                            }),
                            child: Text(
                              'Camera',
                              style: GoogleFonts.lato(fontSize: 16, color: Colors.pink[500]),
                            ),
                          ),
                          FlatButton(
                            onPressed:(() async{
                              _selectedImage = null; //reset _selected image
                              await getImage(ImageSource.gallery, 4, 3); //this sets _selectedImage
                              setState(() {
                                if(_selectedImage != null)_backgroundImage = _selectedImage;
                                Navigator.pop(context); //dismiss alert dialog
                              });
                            }),
                            child: Text(
                              'Gallery',
                              style: GoogleFonts.lato(fontSize: 16, color: Colors.pink[500]),
                            ),
                          ),
                        ],
                      ),
                      barrierDismissible: true,
                    );
                  },
                ),

              ],

            ),
          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}
