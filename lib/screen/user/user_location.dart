
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

 import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


class UserAdress extends StatefulWidget {
  static String id='UserAdress';

  @override
  _UserAdressState createState() => _UserAdressState();
}
class _UserAdressState extends State<UserAdress> {
  Marker marker;
  bool _serviceEnabled;
   LocationData _location;
   PermissionStatus _permissionGranted;
  GoogleMapController _controller ;
  static final CameraPosition initialLocation=CameraPosition(
      target: LatLng(41.011807, 28.525288),zoom: 10
  );
   Location location = new Location();
 List<Marker> markers=[];
  StreamSubscription _locationSubscription;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
      _controller=controller;
    }
    ),
    floatingActionButton: FloatingActionButton(
    child: Icon(Icons.location_searching),
    onPressed: (){

       getCurrentLocation();

    },
    ),);
  }

//  Future<void> checkLocationServicesOnDevice() async {
//    Location location = new Location();
//    _serviceEnabled = await location.serviceEnabled();
//      if(_serviceEnabled)
//        { _permissionGranted = await location.hasPermission();
//        if (_permissionGranted == PermissionStatus.granted){
//          _location = await location.getLocation();
//          print(_location.latitude.toString() + " " + _location.longitude.toString());
//          // بالنسبة للموقع المتحرك
////          location.onLocationChanged.listen((LocationData currentLocation) {
////            print(currentLocation.latitude.toString() + " " + currentLocation.longitude.toString());
////          });
//        }else{
//          _permissionGranted = await location.requestPermission();
//          if(_permissionGranted == PermissionStatus.granted){
//            _location = await location.getLocation();
//            print(_location.latitude.toString() + " " + _location.longitude.toString());
////            location.onLocationChanged.listen((LocationData currentLocation) {
////              print(currentLocation.latitude.toString() + " " + currentLocation.longitude.toString());
////            });
//          }else{
//            Navigator.pop(context);
//            //خروج من البرنامج
////            SystemNavigator.pop();
//          }
//        }
//       }else{
//        _serviceEnabled = await location.requestService();
//        if(_serviceEnabled)
//          {
//            location.onLocationChanged.listen((LocationData currentLocation) {
//              print(currentLocation.latitude.toString() + " " +
//                  currentLocation.longitude.toString());
//            });
//          }else{
//          Navigator.pop(context);
//        }
//      }
//  }
//   storeUserLocation(){
//     Location location = new Location();
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       print(currentLocation.latitude.toString() + " " + currentLocation.longitude.toString());
//       Firestore.instance.collection('Motors').document().setData({
//         'location':GeoPoint(currentLocation.latitude,currentLocation.longitude),
//
//       });
//     });
//     }

  void getCurrentLocation()async{
      _location = await location.getLocation();

      if(_locationSubscription !=null){
        _locationSubscription.cancel();
      }
        if(_controller!=null) {
          _controller.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(_location.latitude, _location.longitude),
                  tilt: 0,
                  zoom: 18.00
              )));
          print(_location.latitude.toString() + " " +
              _location.longitude.toString());
          FirebaseAuth.instance.currentUser().then((user) {
            Firestore.instance.collection('User Location')
                .document(user.uid)
                .setData({
              'location': GeoPoint(_location.latitude, _location.longitude),

            });
          });
        }
  }


    }

