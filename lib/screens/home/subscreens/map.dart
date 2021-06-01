import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/user_data_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';

class MapWidget extends StatefulWidget {
  final List<dynamic> existingLocationData;
  MapWidget({Key key, this.existingLocationData}) : super(key:key);
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {

  GoogleMapController mapController;
  Geolocation location;
  String placeString;
  bool hasExistingData = false;

  @override
  Widget build(BuildContext context) {

    if(widget.existingLocationData != null) hasExistingData = true;
    else hasExistingData = false;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Select Location',
          style: GoogleFonts.lato(fontSize: 24),
        ),
        backgroundColor: Colors.pink[500],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SearchMapPlaceWidget(
              hasClearButton: true,
              placeholder: hasExistingData ? widget.existingLocationData[0] : 'Enter your location',
              placeType: PlaceType.cities,
              apiKey: 'AIzaSyBtsqYzSW4W__FAdmUZ9Cj9EVIoravGAlo',
              onSelected: (Place place) async{
                Geolocation geolocation = await place.geolocation;

                await mapController.animateCamera(
                  CameraUpdate.newLatLng(geolocation.coordinates));
                await mapController.animateCamera(
                  CameraUpdate.newLatLngBounds(geolocation.bounds, 1));

                location = geolocation;
                placeString = place.description;
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              height: 500,
              child: GoogleMap(
                onMapCreated: (GoogleMapController googleMapController){
                  mapController = googleMapController;
                },
                initialCameraPosition: CameraPosition(
                  target: (hasExistingData) ? LatLng(widget.existingLocationData[1], widget.existingLocationData[2]) : LatLng(40.067661, -74.530861),
                  zoom: 15,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:10),
            child: FlatButton(
              color: Colors.pink,
              child: Text(
                'Update',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                if(mounted)sendDataBack(context);
              },
            ),
          )
        ],
      ),
    );
  }
  void sendDataBack (BuildContext context){
    List data = [location, placeString];
    Navigator.pop(context, data);
  }
}
