import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RealTime extends StatefulWidget {
  static String id='RealTime';
  @override
  _RealTimeState createState() => _RealTimeState();
}

class _RealTimeState extends State<RealTime> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers=[];
  static final CameraPosition initialLocation=CameraPosition(
      target: LatLng(41.011807, 28.525288),zoom: 14.5
  );


  @override
  void initState() {
    Firestore.instance.collection('User Location').snapshots().listen((event) {
      event.documentChanges.forEach((change) {
//        print(change.document.data['location'].longitude.toString());
        setState(() {

          markers.add(
              Marker(
                markerId: MarkerId(change.document.documentID),
                infoWindow: InfoWindow(title:change.document.data['Name'].toString()),
                position: LatLng(change.document.data['location'].latitude,change.document.data['location'].longitude),
              ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers.toSet(),
      ),
    );
  }
}
